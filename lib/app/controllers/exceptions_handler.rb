module App::Controllers

  module ExceptionsHandler

    def self.included (controller)
      controller.rescue_from(Exception, with: :handle_exception)
    end

    def handle_exception(exception)
      case exception
      when TypeError, ActiveRecord::RecordInvalid, JSON::ParserError
        error(exception, 400)
      when Mysql2::Error
        is_duplicate_entry = /Duplicate entry/.match(exception.message)
        if is_duplicate_entry
          error(exception, 409)
        else
          error(exception)
        end
      else
        error(exception)
      end
    end

    def error(exception, status = 500)
      log_exception(exception)
      head status: status
    end

    def log_exception(exception)
      return unless exception
      trace = exception.backtrace.map {|line| "    #{line}"}
      lines = ["#{exception.class}: #{exception.message}"] + trace
      logger.error lines.join("\n")
    end

  end

end
