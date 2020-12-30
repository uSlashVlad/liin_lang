/// Main types of lines
enum LineType {
  Definition,
  Command,
  Comment,
  Empty,
}

/// Main types of definitions
enum DefinitionType {
  Simple,
  Complex,
  Command,
  Undef,
  Block,
}
