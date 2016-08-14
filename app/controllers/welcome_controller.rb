class WelcomeController < ApplicationController

  def index
    if params['year'] && params['year'].to_i > 0 then
      @year = params['year'].to_i
    else
      @year = Time.now.year
    end
    if params['month'] && params['month'].to_i >= 1 && params['month'].to_i <= 12 then
      @month = params['month'].to_i
    else
      @month = Time.now.month
    end
  end

  def rps
    @choice = :X
    @choice = params['choice'].to_sym if params['choice']
    @choice_comp = WelcomeHelper::RPSSL.play
    @results = WelcomeHelper::RPSSL.evaluate(@choice, @choice_comp) if WelcomeHelper::RPSSL.valid?(@choice)
  end

end
