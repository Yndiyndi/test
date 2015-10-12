require 'spec_helper'

def get_created_task_from_list content
  on(TasksPage).task_modal_element.when_not_visible
  on(NavigationPage).tasks
  on(TasksPage).get_task content
end

shared_examples "Create task and check it" do |content, remove_date, related, owner|
  it "opens modal and enters task content" do
    on(TasksPage).add_new_task_element.when_visible(10).click
    on(TasksPage).task_content_element.when_visible(10).value = content
  end

  it "deselects due date", :if => remove_date do
    on(TasksPage).uncheck_due_date_toggle
  end

  it "chooses related entity", :if => related do
    element_selector = WrappedElement.new(@current_page.related_to_element).selector
    on(TasksPage).select_related_to(element_selector, related_name)
  end

  it "changes task owner", :if => owner do
    on(TasksPage).change_task_owner owner
  end

  it "saves task" do
    on(TasksPage).create_task
  end

  it "checks if task is visible on tasks list" do
    task = get_created_task_from_list content
    expect(task.link_element(:css => ".related-object").when_visible(5).text).to eq(related_name) if related
  end

  it "checks task details in edit mode" do
    @current_page.edit_task content
    expect(@current_page.task_content).to eq content
    expect(@current_page.displayed_related_to_name_element.when_visible(10).text).to eq(related_name) if related
    expect(@current_page.div_element(:css => ".task-owner").link_element.text).to eq owner if owner
  end
end

describe "Tasks" do
  before(:all) do
    login_to_autotest
    visit(TasksPage)
  end

  after(:all) do
    on(TasksPage).close_modal
  end

  describe "Add floating task" do
    let(:related_name) { nil }
    include_examples "Create task and check it", Faker::Lorem.sentence, true, false, false
  end
end
