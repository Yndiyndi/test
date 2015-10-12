module RelatedToPicker
  include PageObject

  def select_related_to(element_selector, related_to)
    i = 1
    wait_until do
      div_element(element_selector).text_field_element(:css => "input.add-text-field").fill_with_text_via_js related_to
      div_element(element_selector).text_field_element(:css => "input.add-text-field").send_keys :enter if wait_until(5) { div_element(element_selector).text_field_element(:css => "input.add-text-field").value == related_to }
      begin
        div_element(element_selector).unordered_list_element(:css => "div.input-list > ul").
          list_item_element(:text => /#{related_to}/).when_visible(3*i).click
      rescue Watir::Wait::TimeoutError
        i += 1
        false
      end
    end
    wait_until { div_element(element_selector).article_element(:css => "div.collection-view > article").style("background-image") != "none" }
  end
end
