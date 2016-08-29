class API::UptimeRobot::Adapter

  def self.monitors_status
    json = API::UptimeRobot::Driver.monitors_status
    monitors = Hashie::Mash.new(json).monitors.monitor

    monitors = monitors.inject([]) do |acc, monitor|
      params = {}

      monitor.each do |attr|
        params[attr.first.to_sym] = attr.second if keep_attr_list.include? attr.first.to_sym
      end

      acc.push params
    end

    {monitors: monitors}
  end

  def self.keep_attr_list
    [
        :id,
        :friendlyname,
        :url,
        :status,
        :alltimeuptimeratio,
        :customuptimeratio
    ]
  end
end