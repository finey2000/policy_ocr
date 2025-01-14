module PolicyOcr
  # The Digits class contains the visual representations of digits 0-9
  # and a lookup table to map these representations to their corresponding digit characters.
  class Digits
    ZERO = " _ " +
           "| |" +
           "|_|"
           .freeze

    ONE = "   " +
          "  |" +
          "  |"
          .freeze

    TWO = " _ " +
          " _|" +
          "|_ "
          .freeze

    THREE = " _ " +
            " _|" +
            " _|"
            .freeze

    FOUR = "   " +
          "|_|" +
          "  |"
          .freeze

    FIVE = " _ " +
           "|_ " +
           " _|"
           .freeze

    SIX = " _ " +
          "|_ " +
          "|_|"
          .freeze

    SEVEN = " _ " +
            "  |" +
            "  |"
            .freeze

    EIGHT = " _ " +
            "|_|" +
            "|_|"
            .freeze

    NINE = " _ " +
           "|_|" +
           " _|"
           .freeze

    # Lookup table to map the visual representation of each digit to its corresponding character
    MAP = {
      ZERO => '0',
      ONE => '1',
      TWO => '2',
      THREE => '3',
      FOUR => '4',
      FIVE => '5',
      SIX => '6',
      SEVEN => '7',
      EIGHT => '8',
      NINE => '9'
    }.freeze
  end
end
