require 'minitest/autorun'

class Array

  def where(hash = {})

    hash_keys = hash.keys
    hash_values = hash.values
    answer = []
    answer = single_solve(hash_keys[0], hash_values[0])
    if hash.length > 1
      (hash.length - 1).times do |index|
        answer = answer.single_solve(hash_keys[index + 1], hash_values[index + 1])
      end
    end
    return answer
  end

  def single_solve(search_val_1, search_val_2)
    correct_arr = []
    self.each do |person|
      person.each do |k, v|
        correct_arr << person if search_val_2.is_a?(String) && k == search_val_1 && v == search_val_2
        correct_arr << person if search_val_2.is_a?(Integer) && k == search_val_1 && v == search_val_2
        correct_arr << person if search_val_2.is_a?(Regexp) && k == search_val_1 && (v == search_val_2 || search_val_2.match(v) != nil)
      end
    end
    return correct_arr
  end

end

class WhereTest < Minitest::Test

  def setup
    @boris   = {:name => 'Boris The Blade', :quote => "Heavy is good. Heavy is reliable. If it doesn't work you can always hit them.", :title => 'Snatch', :rank => 4}
    @charles = {:name => 'Charles De Mar', :quote => 'Go that way, really fast. If something gets in your way, turn.', :title => 'Better Off Dead', :rank => 3}
    @wolf    = {:name => 'The Wolf', :quote => 'I think fast, I talk fast and I need you guys to act fast if you wanna get out of this', :title => 'Pulp Fiction', :rank => 4}
    @glen    = {:name => 'Glengarry Glen Ross', :quote => "Put. That coffee. Down. Coffee is for closers only.",  :title => "Blake", :rank => 5}

    @fixtures = [@boris, @charles, @wolf, @glen]
  end

  def test_where_with_exact_match
    assert_equal [@wolf], @fixtures.where(:name => 'The Wolf')
  end

  def test_where_with_partial_match
    assert_equal [@charles, @glen], @fixtures.where(:title => /^B.*/)
  end

  def test_where_with_mutliple_exact_results
    assert_equal [@boris, @wolf], @fixtures.where(:rank => 4)
  end

  def test_with_with_multiple_criteria
    assert_equal [@wolf], @fixtures.where(:rank => 4, :quote => /get/)
  end

  def test_with_chain_calls
    assert_equal [@charles], @fixtures.where(:quote => /if/i).where(:rank => 3)
  end
end

