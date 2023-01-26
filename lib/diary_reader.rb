class DiaryReader
  def initialize(wpm, diary)
    fail "WPM must be above 0." unless wpm.positive?
    @wpm = wpm
    @diary = diary
  end

  def find_most_readable_in_time(time)
    readable_entries = @diary.entries.reject do |entry|
      calculate_reading_time(entry) > time
    end
    readable_entries.max_by do |entry|
      count_words(entry)
    end
  end

  private

  def calculate_reading_time(entry)
    return (count_words(entry)/ @wpm.to_f).ceil
  end

  def count_words(entry)
    return 0 if entry.contents.empty?
    entry.contents.split(" ").length
  end
end