module TaskModal
  include PageObject

  div(:task_modal, :css => ".fs-modal-content")
  text_field(:task_content, :id => "content")
  div(:task_due_date, :css => "div.due-date .date.start_at")
  text_field(:task_due_time, :css => "div.due-date .time.start_at")
  checkbox(:due_date_toggle, :css => "div.due-date > input")
  div(:related_to, :css => ".task-context")
  text_field(:related_to_input, :css => ".add-text-field")
  link(:create_task, :class => "btn btn-large btn-primary", :text => "Create")
  link(:update_task, :class => "btn btn-large btn-primary", :text => "Update")
  link(:cancel_task, :class => "btn btn-large", :text => "Cancel")
  link(:delete_task, :class => "btn btn-large destroy-link", :text => "Delete Task")

  def close_modal
    if cancel_task_element.visible?
      cancel_task
      task_modal_element.when_not_visible(3)
    end
  end
end
