using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.IntakeService
{
    public interface IForwarder
    {
        Task<bool> ForwardAsync(Request request);
    }
}
