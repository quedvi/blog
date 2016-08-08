module WelcomeHelper

  def mo_calendar ( year, month )

    current_month = Date.new( year, month, 1 )
    day_week = current_month.strftime("%w").to_i
    days = %w(Sun Mon Tue Wed Thu Fri Sat)

    # calculate how many cells are needed
    full_lines = ( days_month( year, month ) + day_week )/7
    if ( days_month( year, month ) + day_week ).modulo( 7 ) > 0 then
      full_lines += 1
    end
    cells = full_lines*7

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

    # setup table
    cals = "<table border = '1'>"
    # table caption with prev/next links
    cals += "<tr>"
    cals += "<td>"
    cals += link_to "<", calendar_path(year: prev_year, month: prev_month)
    cals += "</td>"
    cals += "<td colspan=5 align='center'>"+current_month.strftime("%B")+" / "+year.to_s
    cals +=" </td>"
    cals += "<td>"
    cals += link_to ">", calendar_path(year: next_year, month: next_month)
    cals += "</td>"
    cals += "</tr>"
    # table header
    cals += "<tr>"
    days.each do |day|
      cals += "<td>#{day}</td>"
    end
    cals += "</tr>"

    # table body
    cals += "<tr align = 'center'>"

    cells.times do |day|
      # every seven days a new line
      if day.modulo(7)==0 then
        cals += "</tr><tr align = 'center'>"
      end

      # blanks at the beginning
      if day < day_week then
        cals += "<td>&nbsp;</td>"
      else
        # regular day?
        if day < ( day_week + days_month( year, month ) ) then
          cals += "<td>"+(day-day_week+1).to_s+"</td>"
        else
          #fill up cells at the end
          cals += "<td>&nbsp;</td>"
        end
      end
    end

    cals += "</tr>"

    # close table and return
    cals += "</table>"
    return cals
  end

  def days_month ( year, month )
    if month == 12 then
      return ( Date.new( year+1, 1, 1 ) - Date.new( year, month, 1 ) ).to_i
    else
      return ( Date.new( year, month+1, 1 ) - Date.new( year, month, 1 ) ).to_i
    end
  end

end
