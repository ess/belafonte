module Belafonte
  class Validator
    attr_reader :errors

    def initialize(app)
      @app = app
      @errors = {}
    end

    def valid?
      error_if_app_lacks_title
      error_if_app_has_multiple_unlimited_args
      error_if_app_has_mounts_and_unlimited_args

      errors.empty?
    end

    def app_title
      app.info(:title)
    end

    private
    def app
      @app
    end

    def record_error(subject, message)
      errors[subject] = message
    end

    def record_error_if(condition, subject, message)
      record_error(subject, message) if condition
    end

    def error_if_app_lacks_title
      record_error_if(
        app.info(:title).nil?,
        :title,
        'must be present'
      )
    end

    def error_if_app_has_multiple_unlimited_args
      record_error_if(
        unlimited_args.length > 1,
        :args,
        "cannot have more than one unlimited arg")
    end

    def error_if_app_has_mounts_and_unlimited_args
      if unlimited_args.length > 1 && command_arg_present?
        record_error(:mounts, 'cannot mount apps if you have unlimited args')
        record_error(:args, 'cannot have unlimited args if you mount apps')
      end
    end

    def unlimited_args
      app.args.select {|arg| arg.unlimited?}
    end

    def command_arg_present?
      !unlimited_args.find {|arg| arg.name.equal?(:command)}.nil?
    end
  end
end
