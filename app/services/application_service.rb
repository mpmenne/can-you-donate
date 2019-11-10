class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  #
  # Testing API used in Services::FacebookCustomAudience::Create
  #

  def success_response(objects = {})
    response = SuccessResponse.new

    objects.each do |key, value|
      response.add_data(key, value)
    end

    response
  end

  def failed_response(objects = {})
    response = FailedResponse.new

    objects.each do |key, value|
      response.add_error(key, value)
    end

    response
  end


  class Response
    def initialize
      @data_hash = HashWithIndifferentAccess.new

      @data_hash[:errors] = {}
    end

    def add_data(key, value)
      data_hash[key] = value
    end

    def add_error(key, value)
      @data_hash[:errors][key] = value
    end

    def failed?
      !success?
    end

    private

      attr_reader :data_hash

      def method_missing(method_name, *args, &block)
        return data_hash[:errors] if method_name.to_s == 'errors'

        data_hash[method_name].presence || super(method_name, *args, &block)
      end
  end

  class SuccessResponse < Response
    def success?
      true
    end
  end

  class FailedResponse < Response
    def success?
      false
    end

    def errors?
      @data_hash[:errors].present?
    end
  end
end