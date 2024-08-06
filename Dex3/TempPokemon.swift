//
//  TempPokemon.swift
//  Dex3
//
//  Created by Davon Allensworth on 7/29/24.
//

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    var hp = 0
    var attack = 0
    var defense = 0
    var specialAttack = 0
    var specialDefense = 0
    var speed = 0
    let sprite: URL
    let shiny: URL
    let animatedFront: URL
    let animatedBack: URL
    let animatedFrontShiny: URL
    let animatedBackShiny: URL

    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites

        enum TypeDictionaryKeys: String, CodingKey {
            case type

            enum TypeKeys: String, CodingKey {
                case name
            }
        }

        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat

            enum StatKeys: String, CodingKey {
                case name
            }
        }

        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
            case versions

            enum VersionKeys: String, CodingKey {
                case generationV = "generation-v"

                enum GenerationVKeys: String, CodingKey {
                    case blackWhite = "black-white"

                    enum BlackWhiteKeys: String, CodingKey {
                        case animated

                        enum AnimatedKeys: String, CodingKey {
                            case front = "front_default"
                            case back = "back_default"
                            case frontShiny = "front_shiny"
                            case backShiny = "back_shiny"
                        }
                    }
                }
            }
        }
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)

        // Types
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)

            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        self.types = decodedTypes

        // Stats
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)

            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp":
                self.hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                self.attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                self.defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                self.specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                self.specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                self.speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("What in tarnation")
            }

        }

        // Sprites
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        self.sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        self.shiny = try spriteContainer.decode(URL.self, forKey: .shiny)

        let versionContainer = try spriteContainer.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.VersionKeys.self, forKey: .versions)

        let genVContainer = try versionContainer.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.VersionKeys.GenerationVKeys.self, forKey: .generationV)

        let blackWhiteContainer = try genVContainer.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.VersionKeys.GenerationVKeys.BlackWhiteKeys.self, forKey: .blackWhite)

        let animatedContainer = try blackWhiteContainer.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.VersionKeys.GenerationVKeys.BlackWhiteKeys.AnimatedKeys.self, forKey: .animated)

        self.animatedFront = try animatedContainer.decode(URL.self, forKey: .front)
        self.animatedBack = try animatedContainer.decode(URL.self, forKey: .back)
        self.animatedFrontShiny = try animatedContainer.decode(URL.self, forKey: .frontShiny)
        self.animatedBackShiny = try animatedContainer.decode(URL.self, forKey: .backShiny)
    }
}
