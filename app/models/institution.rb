class Institution < SaposModels
  def full_name
    "#{name} (#{short_name})" rescue ''
  end
end