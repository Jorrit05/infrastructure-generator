module genLib::Data

// Data type for 'hard' types
data Resources = resourceType(str rType)
                    | dependency(str rDependency)
                    | dependencyList(list[str] rDependencyList)
                    ;


data Patterns
     = Block(map[str, value] block)
     | Map(map[str, value] mapStructure)
     ;
