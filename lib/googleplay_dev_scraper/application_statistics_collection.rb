class GooglePlayDevScraper::ApplicationStatisticsCollection < Array
  def select_by(selector)
    self.select do |element|
      ret = true
      selector.each do |attr, value|
        if element.instance_variable_get("@#{attr}") != value
          ret = false
          break
        end
      end
      ret
    end
  end

  def find_by(selector)
    self.find do |element|
      ret = true
      selector.each do |attr, value|
        if element.instance_variable_get("@#{attr}") != value
          ret = false
          break
        end
      end
      ret
    end
  end
end
