class Broken < Belafonte::App
  title 'broken'
  summary 'This is an intentionally broken application'
  description <<DESC
This application exists solely to test Belafonte's nasty crash (uncaught
exception) handling.

If the innards of an application raise an uncaught error, rather than just
plain bombing out, we should exit cleanly with a fatal error status.
DESC

  def handle
    raise "This is why we can't have nice things."
  end
end
