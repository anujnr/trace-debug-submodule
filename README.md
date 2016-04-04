# trace-debug-submodule
This is the backpressure module that dispatches the continuous flow of trace debug messages from the core to a ready-valid interface using axi-like protocol. When the receving interface is ready after a disruption, this module is responsible for generating an error message with a count of missed trace messages.
