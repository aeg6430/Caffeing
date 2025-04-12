namespace Caffeing.Infrastructure
{
    public class DatabaseSettings
    {
        public string Provider { get; set; }
        public DatabaseConnectionSettings Connection { get; set; }
    }

    public class DatabaseConnectionSettings
    {
        public string DataSource { get; set; }
        public string InitialCatalog { get; set; }
        public string UserId { get; set; }
        public string Password { get; set; }
        public string Pooling { get; set; }
        public string MaxPoolSize { get; set; }
        public string ConnectTimeout { get; set; }
    }

}
