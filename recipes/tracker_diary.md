# {{PROBLEM}} Multi-Class Planned Design Recipe

## 1. Describe the Problem

> As a user  
> So that I can record my experiences  
> I want to keep a regular diary

> As a user  
> So that I can reflect on my experiences  
> I want to read my past diary entries 

> As a user  
> So that I can reflect on my experiences in my busy day  
> I want to select diary entries to read based on how much time I have and my
> reading speed

> As a user  
> So that I can keep track of my tasks  
> I want to keep a todo list along with my diary

> As a user  
> So that I can keep track of my contacts  
> I want to see a list of all of the mobile phone numbers in all my diary
> entries

## 2. Design the Class System

_Consider diagramming out the classes and their relationships. Take care to
focus on the details you see as important, not everything. The diagram below
uses asciiflow.com but you could also use excalidraw.com, draw.io, or miro.com_

```
┌───────────────────────────┐             ┌───────────────────────┐
│ Diary                     │             │ TodoList              │
│ ------                    │             │ --------              │
│ - add entries             │             │ - add todo            │
│                           │             │ - see todos           │
│                           │             │                       │
│                           │             │                       │
│                           │             │                       │
│                           │             │                       │
│                           │             │                       │
└───────────────────────────┘             └───────────────────────┘




┌───────────────────────────┐             ┌───────────────────────┐
│ PastEntries               │             │ ContactTracker        │
│ -----------               │             │ --------------        │
│ - see past entries        │             │ - add contacts        │
│                           │             │                       │
│                           │             │                       │
│                           │             │                       │
│                           │             │                       │
│                           │             │                       │
│                           │             │                       │
└───────────────────────────┘             └───────────────────────┘



┌───────────────────────────┐
│ BusyDays                  │
│ --------                  │
│ - select diary entries    │
│ - reading speed           │
│ - time left               │
│ - word count              │
│                           │
│                           │
│                           │
└───────────────────────────┘

```

_Also design the interface of each class in more detail._

```ruby
class Diary
  def add(entry) # entry is an instance of DiaryEntry
  end

  def entries
    # Returns a list of DiaryEntries
  end

end

class DiaryEntry
  def initialize(title, contents) # title and contents are both strings
  end

  def title 
    # Returns title as a string
  end

  def contents
    # Returns contents as a string
  end
end

class PhoneBook
  def initialize(diary) # diary is a instance of Diary
  end

  def extract_numbers
    # Returns a list of strings representing phone numbers
    # gathered across all diary entries
  end
end

class DiaryReader
  def initialize(wpm, diary)
    # wpm is a number representing how many words the reader can read
    # in one minute
    # diary is an instance of Diary
  end

  def find_most_readable_in_time(time)
    # Returns an instance of the DiaryEntry, corresponding to the entry
    # with the longest content that is still readable within the time,
    # based on the wpm specified earlier
  end
end

class TaskList
  def add(task) # task is an instance of Task
  end

  def all
   # Returns a list of tasks
  end
end

class Task
  def initialize(title) # title is a string
  end
  
  def title
    # Returns the title as a string
  end
end

```

## 3. Create Examples as Integration Tests

#1

diary = Diary.new
entry_1 = DiaryEntry.new("my title", "my contents")
entry_2 = DiaryEntry.new("my title 2", "my contents 2")
diary.add(entry_1)
diary.add(entry_2)
expect(diary.entries).to eq [entry_1, entry_2]


#2 fits exactly

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
expect(reader.find_most_readable_intime(2)).to eq entry_4


#3 does not fit exactly

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
expect(reader.find_most_readable_intime(2)).to eq entry_3


#4 nothing readable at time

diary = Diary.new
reader = DiaryReader.new(2, diary)
entry = DiaryEntry.new("title", "one two thee four five")
diary.add(entry)
expect(reader.find_most_readable_intime(2)).to eq nil

#5 nothing at all

diary = Diary.new
reader = DiaryReader.new(2, diary)
expect(reader.find_most_readable_intime(2)).to eq nil

#6 wpm invalid

diary = Diary.new
reader = DiaryReader.new(0, diary)
expect { reader.find_most_readable_intime(2) }.to raise error "WPM must be above 0."

#7

task_list = TaskList.new
task_1 = Task.new("walk the dog")
task_2 = Task.new("walk the cat")
task_list.add(task_1)
task_list.add(task_2)
expect(task_list.all).to eq [task_1, task_2]

#8

diary = Diary.new
phone_book = PhoneNumberCrawler.new(diary)
diary.add(DiaryEntry.new("title1", "my friend 07000001 is cool"))
diary.add(DiaryEntry.new("title2", "my friends 07000001, 07000002, 07000003 and 07000003 are cool"))
expect(phone_book.extract_numbers).to eq ["07000001", "07000002", "07000003"]

```ruby
# EXAMPLE

# Gets all tracks

```

## 4. Create Examples as Unit Tests

_Create examples, where appropriate, of the behaviour of each relevant class at
a more granular level of detail._

```ruby
# EXAMPLE
#TaskList
#1

diary = Diary.new
diary_entry = DiaryEntry.new
expect(diary.entries).to eq []

#2

task_list = TaskList.new
task_list.complete? # => []

#Task

#1

task = Task.new("walk the dog")
task.title # => "walk the dog"

#2

task = Task.new("walk the dog")
task.complete? # => false

#3

task = Task.new("walk the dog")
task.mark_complete
task.complete? # => true

```

_Encode each example as a test. You can add to the above list as you go._

## 5. Implement the Behaviour

_After each test you write, follow the test-driving process of red, green,
refactor to implement the behaviour._


<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fmulti_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fmulti_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fmulti_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fmulti_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fmulti_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->