module App::Controllers

  module ExceptionsHandler

    def self.included (controller)
      controller.rescue_from(Exception, with: :handle_exception)
    end

    def handle_exception(exception)
      case exception
      when ActiveRecord::RecordInvalid
        head status: 400
      when Mysql2::Error
        is_duplicate_entry = /Duplicate entry/.match(exception.message)
        head status: 409 if is_duplicate_entry
        server_error(exception) unless is_duplicate_entry
      else
        server_error(exception)
      end
    end

    def server_error(exception)
      log_exception(exception)
      head status: 500
    end

    def log_exception(exception)
      return unless exception
      trace = exception.backtrace.map {|line| "    #{line}"}
      lines = ["#{exception.class}: #{exception.message}"] + trace
      logger.error lines.join("\n")
    end

  end

end
