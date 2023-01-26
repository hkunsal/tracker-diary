require "diary"
require "diary_entry"
require "diary_reader"
require "phone_number_crawler"

RSpec.describe "diary_integration" do
  it "adds diary entries" do
    diary = Diary.new
    entry_1 = DiaryEntry.new("my title", "my contents")
    entry_2 = DiaryEntry.new("my title 2", "my contents 2")
    diary.add(entry_1)
    diary.add(entry_2)
    expect(diary.entries).to eq [entry_1, entry_2]
  end

  describe "diary reading behavior" do
    context "where there is a perfect diary entry to read in the time" do
      it "finds that entry" do
        diary = Diary.new
        reader = DiaryReader.new(2, diary)
        entry_1 = DiaryEntry.new("title1", "one")
        entry_2 = DiaryEntry.new("title2", "one two")
        entry_3 = DiaryEntry.new("title3", "one two three")
        entry_4 = DiaryEntry.new("title3", "one two three four")
        entry_5 = DiaryEntry.new("title3", "one two three four five")
        diary.add(entry_1)
        diary.add(entry_2)
        diary.add(entry_3)
        diary.add(entry_4)
        diary.add(entry_5)
        expect(reader.find_most_readable_in_time(2)).to eq entry_4
      end
    end

    context "where the entry is a bit shorter than optimum" do
      it "returns that entry" do
        diary = Diary.new
        reader = DiaryReader.new(2, diary)
        entry_1 = DiaryEntry.new("title1", "one")
        entry_2 = DiaryEntry.new("title2", "one two")
        entry_3 = DiaryEntry.new("title3", "one two three")
        entry_5 = DiaryEntry.new("title4", "one two three four five")
        diary.add(entry_1)
        diary.add(entry_2)
        diary.add(entry_3)
        diary.add(entry_5)
        expect(reader.find_most_readable_in_time(2)).to eq entry_3
      end
    end

    context "where there is nothing readable" do
      it "returns nil" do
        diary = Diary.new
        reader = DiaryReader.new(2, diary)
        entry = DiaryEntry.new("title", "one two thee four five")
        diary.add(entry)
        expect(reader.find_most_readable_in_time(2)).to eq nil
      end
    end

    context "when there is nothing at all (empty diary)" do
      it "returns nil" do
        diary = Diary.new
        reader = DiaryReader.new(2, diary)
        expect(reader.find_most_readable_in_time(2)).to eq nil
      end
    end


    context "when WPM is invalid" do
      it "raises an error" do
        diary = Diary.new
        expect { DiaryReader.new(0, diary) }.to raise_error "WPM must be above 0."
      end
    end
  end

  describe "phone number extraction behavior" do
    it "extracts phone numbers from all diary entries" do
      diary = Diary.new
      phone_book = PhoneNumberCrawler.new(diary)
      diary.add(DiaryEntry.new("title1", "my friend 0700000001 is cool"))
      diary.add(DiaryEntry.new("title2", "my friends 07000000001, 07000000002, 07000000003 and 07000000003 are cool"))
      diary.add(DiaryEntry.new("title3", "invalid number"))
      expect(phone_book.extract_numbers).to eq ["07000000001", "07000000002", "07000000003"]
    end

    it "doesn't extract invalid numbers" do
      diary = Diary.new
      phone_book = PhoneNumberCrawler.new(diary)
      diary.add(DiaryEntry.new("title1", "my friends 0700000001 and 17000000002 are cool"))
      expect(phone_book.extract_numbers).to eq []
    end
  end
end