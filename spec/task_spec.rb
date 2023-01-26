require "task"

RSpec.describe Task do
  it "constructs" do
    task = Task.new("walk the dog")
    expect(task.title).to eq "walk the dog"
  end
end
