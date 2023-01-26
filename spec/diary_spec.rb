require "diary"

RSpec.describe Diary do
  it "initally" do
    diary = Diary.new
    expect(diary.entries).to eq []
  end
end