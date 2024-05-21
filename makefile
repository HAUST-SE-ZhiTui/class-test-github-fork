# Makefile for C language exercise project

# Define the directory where the exercise files are stored
EXERCISE_DIR = ./exercises

# Define the test directory
TEST_DIR = ./test

# Ensure the test directory exists
$(shell mkdir -p $(TEST_DIR))

# Define the list of exercises
EXERCISES = $(wildcard $(EXERCISE_DIR)/*.c)

# Define the list of object files
OBJECTS = $(patsubst $(EXERCISE_DIR)/%.c, %.o, $(EXERCISES))

# Define the final executable
EXECUTABLE = exercises

# Default target: build the executable
all: $(EXECUTABLE)

# Build rule for the executable
$(EXECUTABLE): $(OBJECTS)
    gcc -o $@ $^

# Build rule for each object file
%.o: $(EXERCISE_DIR)/%.c
    gcc -c -o $@ $<

# Clean rule to remove object files and the executable
clean:
    rm -f $(OBJECTS) $(EXECUTABLE)

# Test rule to run the executable
test: $(EXECUTABLE)
    ./$(EXECUTABLE)

# Include the exercise files
-include $(EXERCISES:%.c=%.d)

# Dependency generation for each exercise file
$(EXERCISE_DIR)/%.d: $(EXERCISE_DIR)/%.c
    @set -e; rm -f $@; \
    gcc -MM $(<) > $@.$$$$; \
    sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
    rm -f $@.$$$$

# Include the generated dependencies
-include $(EXERCISES:%.c=%.d)

# Test rule to compare output with expected results
test-output: $(EXECUTABLE)
    for exercise in $(EXERCISES); do \
        exercise_name=$$(basename $$exercise .c); \
        expected=$$(cat $(TEST_DIR)/$${exercise_name}.out); \
        actual=$$(./$(EXECUTABLE) < $(EXERCISE_DIR)/$${exercise_name}.c); \
        if [ "$$expected" = "$$actual" ]; then \
            echo "Test for $$exercise_name passed."; \
        else \
            echo "Test for $$exercise_name failed."; \
            echo "Expected:"; echo "$$expected"; \
            echo "Actual:"; echo "$$actual"; \
        fi; \
    done
