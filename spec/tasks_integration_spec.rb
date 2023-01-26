require "task_list"
require "task"

RSpec.describe "tasks integration" do
  it "adds tasks to a list" do
    task_list = TaskList.new
    task_1 = Task.new("walk the dog")
    task_2 = Task.new("walk the cat")
    task_list.add(task_1)
    task_list.add(task_2)
    expect(task_list.all).to eq [task_1, task_2]
  end
end