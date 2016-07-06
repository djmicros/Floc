module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Floc - Store, share and find your amazing film locations!"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end