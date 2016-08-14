module WelcomeHelper

# helper for calendar
  def mo_calendar ( year, month , width, height )

    current_month = Date.new( year, month, 1 )
    day_week = current_month.strftime("%w").to_i
    #days = %w(S M T W T F S)
    days = %w(Sun Mon Tue Wed Thu Fri Sat)

    full_lines = 6  # for static number of rows
    cells = full_lines * 7

    # month and year for next/previous month
    next_month = month + 1
    next_year = year
    if next_month > 12 then
      next_month = 1
      next_year = year + 1
    end
    prev_month = month - 1
    prev_year = year
    if prev_month <= 0 then
      prev_month = 12
      prev_year = year - 1
    end

    cals  = "<div style='overflow-x:auto;'>"
    # setup table
    cals += "<table class='MO-cal' style='width: #{width}px; height: #{height}px;'>"

    # table caption with prev/next links
    cals += "<tr class='MO-cal'>"
    cals += "<td class='MO-cal MO-cal-caption' colspan=5>"+current_month.strftime("%B")+" "+year.to_s
    cals +=" </td>"
    cals += "<td class='MO-cal MO-cal-nav' colspan='2'>"
    cals += link_to "&#x2C4;".html_safe, calendar_path(year: prev_year, month: prev_month), class: "no_decoration"
    cals += "&nbsp;&nbsp;&nbsp;"
    cals += link_to "&#x2C5;".html_safe, calendar_path(year: next_year, month: next_month), class: "no_decoration"
    cals += "</td>"
    cals += "</tr>"
    # table header
    cals += "<tr class='MO-cal'>"
    days.each do |day|
      cals += "<td class='MO-cal MO-cal-heading'>#{day}</td>"
    end
    cals += "</tr>"

    # table body
    cals += "<tr class='MO-cal'>"

    cells.times do |cell|
      # every seven days a new line
      if cell.modulo(7)==0 then
        cals += "</tr><tr class='MO-cal'>"
      end

      # last month at the beginning /// check year switch
      if cell < day_week then
        cals += "<td class='MO-cal MO-cal-inactive'>#{fill_last_month(year, month-1, cell-day_week)}</td>"
      else
        # regular day?
        if cell < ( day_week + days_month( year, month ) ) then
          # mark today
          if [ Time.now.day, Time.now.month, Time.now.year ] == [ cell-day_week+1, month, year ]
            cals += "<td class='MO-cal MO-cal-today'>#{(cell-day_week+1).to_s}</td>"
          else
            cals += "<td class='MO-cal'>#{(cell-day_week+1).to_s}</td>"
          end
        else
          #fill up next month at the end   /// check year switch
          cals += "<td class='MO-cal MO-cal-inactive'>#{fill_next_month(year, month+1, cell-day_week + 1)}</td>"
        end
      end
    end

    cals += "</tr>"

    # close table and return
    cals += "</table>"
    cals += "</div>"
    #cals += "Month: #{month} / Year: #{year} <br/> #{Date.new( year, month, -1 ).day}"
    #cals += "#{Time.now.day} / #{Time.now.month} / #{Time.now.year} "
    return cals
  end

  def fill_last_month( year, last_month, last_day )
    return Date.new(year, last_month, last_day).day if last_month > 0
    return Date.new(year-1, 12, last_day).day if last_month <= 0
  end

  def fill_next_month( year, next_month, first_day )
    return Date.new(year, next_month, first_day - Date.new( year, next_month-1 , -1 ).day ).day if next_month <= 12
    return Date.new(year+1, 1, first_day - Date.new( year, next_month-1 , -1 ).day ).day if next_month > 12
  end

  def days_month ( year, month )
    if month == 12 then
      return ( Date.new( year+1, 1, 1 ) - Date.new( year, month, 1 ) ).to_i
    else
      return ( Date.new( year, month+1, 1 ) - Date.new( year, month, 1 ) ).to_i
    end
  end

# Class for Rock-Paper-Scissors-Spock-Lizard
  class RPSSL
    @@rps = {
      A: "Rock",
      B: "Paper",
      C: "Scissors",
      D: "Spock",
      E: "Lizard"
    }
    @@rps_links = {
      A: [ [ "crushes",     :C ], [ "crushes",     :E ] ],
      B: [ [ "covers",      :A ], [ "disproves",   :D ] ],
      C: [ [ "cuts",        :B ], [ "decapitates", :E ] ],
      D: [ [ "smashes",     :C ], [ "vaporizes",   :A ] ],
      E: [ [ "poisons",     :D ], [ "eats",        :B ] ]
    }

    def RPSSL.item (key)
      return @@rps[key]
    end

    def RPSSL.valid? (key)
      return @@rps.has_key?(key)
    end

    def RPSSL.play
      return { 1 => :A, 2 => :B, 3 => :C, 4 => :D, 5 => :E }[rand(1..5)]
    end

    def RPSSL.evaluate ( user, computer )
      return [ user, '==', computer, 'DRAW'] if user == computer
      @@rps_links[user].each do |value, key| # win conditions
        return [user, value, computer, 'WIN'] if key == computer
      end
      @@rps_links[computer].each do |value, key| # loose conditions
        return [ computer, value, user, 'LOSS'] if key == user
      end
    end

  end

  def card (choice_link, selector)
    return "<div class='floating #{selector}'>
              #{link_to(card_text(choice_link).html_safe, rps_path(choice: choice_link), class: "no_decoration")}
            </div>"
  end

  def card_text (choice_link)
    return "<div>
              <div class='cardhead'>
                #{RPSSL.item(choice_link)}
              </div>
              #{image_tag( RPSSL.item(choice_link).downcase+'.jpg', size: '100x100', alt: RPSSL.item(choice_link) )}
            </div>"
  end

  def result (result_text)
    return "<span style='font-weight: bold; color: "+ result_color(result_text)+"'>#{result_text}:</span>"
  end

  def result_color(result_text)
    return "#008000" if result_text == "WIN"
    return "#666666" if result_text == "DRAW"
    return "#FF0000" if result_text == "LOSS"
    return "black"
  end
end
