require "diary_entry"

RSpec.describe DiaryEntry do
  it "constructs" do
    diary_entry = DiaryEntry.new("my title", "my contents")
    expect(diary_entry.title).to eq "my title"
    expect(diary_entry.contents).to eq "my contents"
  end
end