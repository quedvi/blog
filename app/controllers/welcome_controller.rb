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
    @selector = { A: "input",
                  B: "input",
                  C: "input",
                  D: "input",
                  E: "input"
                }
    @choice = :X
    if params['choice']
      @choice = params['choice'].to_sym
    end
    @choice_comp = WelcomeHelper::RPSSL.play
    if WelcomeHelper::RPSSL.valid?(@choice)
      @results = WelcomeHelper::RPSSL.evaluate(@choice, @choice_comp)
      @selector[@choice] = "selected"
    end
  end

end
