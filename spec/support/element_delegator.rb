require 'delegate'
require 'page-object'

module PageObject
  module Elements
    class Element

      def element
        ElementDelegator.new(@element)
      end

    end
  end
end

class ElementDelegator < Delegator

  def initialize(obj)
    super
    @delegate_sd_obj = obj
  end

  def method_missing(m, *args, &block)
    tries = 0
    begin
      tries += 1
      super
    rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
      tries < 5 ? retry : raise("Delegator didn't saved you from #{e.class.to_s} => #{e}")
    rescue Watir::Exception::UnknownObjectException => e
      if tries < 5 then
        sleep 0.2
        retry
      else
        raise("Delegator didn't saved you from #{e.class.to_s} - #{e}")
      end
    end
  end

  def __getobj__
    @delegate_sd_obj
  end

  def __setobj__(obj)
    @delegate_sd_obj = obj
  end
end
