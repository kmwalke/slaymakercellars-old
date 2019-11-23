module ApplicationHelper
  def active(name, base_class = '')
    if name == controller.controller_name
      'active' + ' ' + base_class
    else
      base_class
    end
  end

  def humanize_time(time)
    time.strftime('%I:%M %p')
  end

  def humanize_date(date)
    date.strftime('%a, %b %d, %Y')
  end

  def humanize_date_time(date_time)
    date_time.strftime('%A, %B %d, %Y - %I:%M %p')
  end

  def sortable(column, title = nil)
    title   ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, params.permit(:active, :target, :misc, :urgent, :inactive).merge(sort: column, direction: direction, page: nil), class: css_class
  end
end
