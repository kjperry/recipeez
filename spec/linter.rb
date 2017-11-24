describe "markdown" do
  Dir[File.dirname(__FILE__) + '/../*.md'].each do |file|
    it "should have an Ingredients and Steps section, and no others" do
      ingredients = false
      steps = false
      others = false
      File.open(file).each_line do |line|
        if line.start_with?("## Ingredients")
          ingredients = true
        elsif line.start_with?("## Steps")
          steps = true
        elsif line.start_with?("## ")
          others = true
        end
      end

      file = file.split("/").last
      expect(ingredients).to be_truthy, "#{file} missing ingredients section"
      expect(steps).to be_truthy, "#{file} missing steps section"
      expect(others).to be_falsey, "#{file} has extra or misnamed sections"
    end

    it "has at least one step and one ingredient in proper format" do
      step = false
      ingredient = false
      File.open(file).each_line do |line|
        if line.start_with?("*")
          step = true
        elsif line.start_with?("1.")
          ingredient = true
        end
      end

      file = file.split("/").last
      expect(step).to be_truthy, "#{file} missing steps or has improper format"
      expect(ingredient).to be_truthy, "#{file} missing ingredients or has improper format"
    end

    it "has spaces between list formatting and list items" do
      File.open(file).each_line do |line|
        if line.start_with?("*") && !line.start_with?("* ")
          fail "#{file.split("/").last} has misformatted ingredients"
        elsif line.start_with?("1.") && !line.start_with?("1. ")
          fail "#{file.split("/").last} has misformatted steps"
        end
      end
    end
  end
end
