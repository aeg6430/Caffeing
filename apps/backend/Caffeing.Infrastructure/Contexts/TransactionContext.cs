using Caffeing.Infrastructure;
using Caffeing.Infrastructure.Contexts;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;
using MySql.Data.MySqlClient;
using Npgsql;
using System.Data;

public class TransactionContext : IDisposable
{
    private readonly DatabaseSettings _settings;
    private readonly ILogger<TransactionContext>? _logger;

    public IDbConnection Connection { get; private set; }
    public IDbTransaction Transaction { get; private set; }

    public TransactionContext(DatabaseSettings settings, ILogger<TransactionContext>? logger = null)
    {
        _settings = settings;
        _logger = logger;
    }

    public IDbConnection CreateConnection()
    {
        var provider = Enum.TryParse<DbProvider>(_settings.Provider, ignoreCase: true, out var parsedProvider)
            ? parsedProvider
            : throw new NotSupportedException($"Invalid provider: {_settings.Provider}");

        var connectionString = BuildConnectionString(_settings, provider);

        switch (provider)
        {
            case DbProvider.SqlServer:
                return new SqlConnection(connectionString);
            case DbProvider.PostgreSql:
                return new NpgsqlConnection(connectionString);
            case DbProvider.MySql:
                return new MySqlConnection(connectionString);
            default:
                throw new NotSupportedException($"Provider {provider} is not supported.");
        }
    }

    private string BuildConnectionString(DatabaseSettings settings, DbProvider provider)
    {
        var connect = settings.Connection;
        switch (provider)
        {
            case DbProvider.SqlServer:
                return $"Data Source={connect.DataSource};Initial Catalog={connect.InitialCatalog};User ID={connect.UserId};Password={connect.Password};" +
                       $"Pooling={connect.Pooling};Max Pool Size={connect.MaxPoolSize};Connect Timeout={connect.ConnectTimeout};";

            case DbProvider.PostgreSql:
                return $"Host={connect.DataSource};Database={connect.InitialCatalog};Username={connect.UserId};Password={connect.Password};" +
                       $"Pooling={connect.Pooling};Command Timeout={connect.ConnectTimeout};";

            case DbProvider.MySql:
                return $"Server={connect.DataSource};Database={connect.InitialCatalog};User={connect.UserId};Password={connect.Password};" +
                       $"Pooling={connect.Pooling};Max Pool Size={connect.MaxPoolSize};Connect Timeout={connect.ConnectTimeout};";

            default:
                throw new NotSupportedException($"Provider {provider} is not supported.");
        }
    }

    /// <summary>
    /// Executes a database operation inside a transaction.
    /// This method opens a connection, begins a transaction, executes the operation, and commits the transaction.
    /// If an error occurs, it rolls back the transaction.
    /// </summary>
    public async Task ExecuteAsync(Action<IDbConnection, IDbTransaction> operation)
    {
        try
        {
            await OpenConnectionAsync();
            BeginTransaction();

            operation(Connection, Transaction);

            CommitTransaction();
        }
        catch (Exception ex)
        {
            RollbackTransaction();
            _logger?.LogError(ex, "Transaction failed");
            throw;
        }
        finally
        {
            CloseConnection();
        }
    }

    public void Begin()
    {
        OpenConnectionAsync();
        BeginTransaction();
    }

    public void Commit()
    {
        CommitTransaction();
    }

    public void Rollback()
    {
        RollbackTransaction();
    }

    public void Dispose()
    {
        CloseConnection();
    }

    private async Task OpenConnectionAsync()
    {
        Connection = CreateConnection();
        Connection.Open();
    }

    private void BeginTransaction()
    {
        Transaction = Connection.BeginTransaction();
    }

    private void CommitTransaction()
    {
        Transaction?.Commit();
    }

    private void RollbackTransaction()
    {
        Transaction?.Rollback();
    }

    private void CloseConnection()
    {
        Transaction?.Dispose();
        Connection?.Close();
        Connection?.Dispose();
    }
}
