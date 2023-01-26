class PhoneNumberCrawler
  def initialize(diary) # diary is a instance of Diary
    @diary = diary
  end

  def extract_numbers
    return @diary.entries.map do |entry|
      extract_numbers_from_entry(entry)
    end.flatten.uniq
  end

  private

  def extract_numbers_from_entry(entry)
    return entry.contents.scan(/07[0-9]{9}/)
  end
end