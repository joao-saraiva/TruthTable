def identify_logical_syntax(expression)
    formated_expressions = expression.split(/[ ,]/)
    completeds_draws =  Array.new
    total_variables = Array.new

    formated_expressions.each do |formated_expression|
        formated_expression.chars.each do |character|
            unless is_operator?(character)
                total_variables.push(character)
            end
        end
    end

    total_variables = total_variables.uniq
    total_drew_variables = 1
    rows = Array.new

    for x in 1..(total_rows(total_variables.size) + 1) * 2
        rows.push(Array.new)
    end

    formated_expressions.each do |formated_expression|
        formated_expression.chars.each do |character|
            if !is_operator?(character) && !completeds_draws.include?(character)
                completeds_draws.push(character)
                new_rows = create_rows(character, total_rows(total_variables.size), total_drew_variables)

                new_rows.each_with_index do |new_row, index|
                    rows[index].push(new_row)
                end

                total_drew_variables = total_drew_variables * 2
            end
        end
        rows[0].push( "  #{formated_expression}  |")
    end

    rows.each_with_index do |row, index_row|
        if index_row == 0
            row.each_with_index do |column, column_index|
                sentence = column
                sentence = sentence.split('').reject { |v| v == ' ' || v == '|'}.join('')

                if sentence.size > 1
                    variables = sentence.split(/[ ^v -> <->]/)
                    variables = variables.reject { |v| v == ''}
                    reject_expression = "#{variables[0]}" + "#{variables[1]}"

                    operator = expression.split(/["#{reject_expression}"]/)
                    first_variables_valeus = Array.new
                    second_variables_valeus = Array.new

                    row.each_with_index do |column, internal_column_index|
                        variable_row = row[internal_column_index].split('').reject { |v| v == ' ' || v == '|'}.join('')

                        if variable_row == variables[0]

                            for internal_row_index in 1..rows.size
                                
                                if rows[internal_row_index] != nil && rows[internal_row_index][internal_column_index] != nil
                                    current_value = rows[internal_row_index][internal_column_index].split('').reject { |v| v == ' ' || v == '|'}.join('')
                                else
                                    current_value = nil
                                end

                                if current_value != '-------' && current_value != nil
                                    first_variables_valeus.push(current_value)
                                end
                            end

                        elsif variable_row == variables[1]
                            for internal_row_index in 1..rows.size
                                if rows[internal_row_index] != nil && rows[internal_row_index][internal_column_index] != nil
                                    current_value = rows[internal_row_index][internal_column_index].split('').reject { |v| v == ' ' || v == '|'}.join('')
                                else
                                    current_value = nil
                                end

                                if current_value != '-------' && current_value != nil
                                    second_variables_valeus.push(current_value)
                                end
                            end
                        end
                    end
                    column_index

                    inserted_elements = 0
                    rows.each_with_index do |insert_row, insert_index|
                        if insert_row[column_index] != '-------' && insert_index != 0 && insert_index % 2 == 0
                            value1 = first_variables_valeus[inserted_elements] == 'V'
                            value2 = second_variables_valeus[inserted_elements] == 'V'
                            
                            insert_row[column_index] = solve_expression(operator[1], value1, value2)
                            inserted_elements += 1
                        elsif insert_index != 0 && insert_index == 1 || insert_index % 2 != 0
                            insert_row[column_index] = '-------'
                        end
                    end
                end
            end
        end

        entire_row = row.join("")
        puts entire_row
    end
end

def solve_expression(operator, value1, value2)
    if is_and?(operator)
        return value1 && value2 ? '   V   |' : '   F   |'
    elsif is_or?(operator)
        return value1 || value2 ? '   V   |' : '   F   |'
    end
end

def create_rows(expression, total_rows, total_drew_variables)
    elements = Array.new
    if !is_operator?(expression) && expression.size == 1
        elements.push("  #{expression.chars.last}   |")
        elements.push('-------')
        true_counter = 0
        current_leter = 'V'
        for x in 1..total_rows
            if true_counter == total_drew_variables
                current_leter = current_leter == 'V' ? 'F' : 'V'
                true_counter = 0
            end

            true_counter += 1
            elements.push("  #{current_leter}   |")
            elements.push('-------')
        end
    end
    return elements
end

def total_rows(total_variables)
    return 2 ** total_variables
end

def is_operator?(operator)
    valids_operators = ['v', '^', '~', '->', '<->']
    return valids_operators.include?(operator)
end

def is_negative?(operator)
    return operator == '~'
end

def is_and?(operator)
    return operator == '^'
end

def is_or?(operator)
    return operator == 'v'
end

def valid_by_bff?
end