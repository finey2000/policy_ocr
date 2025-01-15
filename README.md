# Policy OCR Application

## Overview

The Policy OCR (Optical Character Recognition) application is designed to process input files containing OCR digit lines, extract policy numbers, validate them, and export the results to an output file. This application is built using Ruby and includes a few classes to handle different aspects of the process.

See [problem statement](problem_statement.md) for more details.

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/finey2000/policy_ocr.git
   cd policy_ocr
   ```

2. Install the required gems:
   ```sh
   bundle install
   ```

### System Dependencies
```plaintext
Ruby 3.0.1
```

## Usage

To use the application, you can call the `PolicyOcr::FileProcessor.perform` method with the input and output file paths.

### Example

```ruby
require_relative 'lib/policy_ocr/file_processor'

input_file = 'path/to/input_file.txt'
output_file = 'path/to/output_file.txt'

PolicyOcr::FileProcessor.perform(input_file, output_file)
```

This will read the OCR digit lines from the input file, extract and validate the policy numbers, and write the results to the output file.

## Implementation Highlights

1. **Modular Design:**
   - The application is designed with modular classes, making it easy to extend or modify individual components without affecting the entire system.

2. **Validation:**
   - The `ChecksumValidator` class can be extended to support different validation algorithms if needed.

3. **Digit Mapping:**
   - The `Digits` class uses a lookup table for efficient digit recognition, which can be easily updated to support additional characters, formats or possible alternatives.

4. **Parallel Processing:**
   - The import and export methods can be optimized to run in parallel, improving performance for large datasets.

5. **Support for Different Formats:**
   - The application can be extended to import and export data in different formats such as JSON or SQL. This would involve adding new methods to handle the conversion of policy numbers to and from these formats, making the application more versatile and adaptable to different use cases.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a new Pull Request.

---

This documentation provides an overview of the Policy OCR application, its usage, and highlights areas that support scalability. For more detailed information, refer to the source code and inline documentation.