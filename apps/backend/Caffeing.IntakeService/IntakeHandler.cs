using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.IntakeService
{
    public class IntakeHandler
    {
        private readonly Verifier _verifier;
        private readonly IForwarder _forwarder;

        public IntakeHandler(Verifier verifier, IForwarder forwarder)
        {
            _verifier = verifier;
            _forwarder = forwarder;
        }

        public async Task<bool> HandleAsync(Request request)
        {
            var isValid = await _verifier.VerifyAsync(request.Token);
            if (!isValid) 
            {
                return false;
            }

            var success = await _forwarder.ForwardAsync(request);
            if (!success)
            { 
                return false;
            }

            return true;
        }
    }
}
