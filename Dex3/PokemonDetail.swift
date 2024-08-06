//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Davon Allensworth on 7/29/24.
//

import SwiftUI
import CoreData
import AVFoundation
import SDWebImageSwiftUI

struct PokemonDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny = false
    @State var showBack = false

    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)

                WebImage(url: currentImageURL())
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 2)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 400)
                        .onTapGesture {
                            showBack.toggle()
                        }
            }

            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding([.top, .bottom], 7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(25)
                }

                Spacer()

                Button {
                    withAnimation {
                        pokemon.favorite.toggle()

                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                } label: {
                    if pokemon.favorite {
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
                .font(.title)
                .foregroundStyle(.yellow)
            }
            .padding()

            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)

            Stats()
                .environmentObject(pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showShiny.toggle()
                } label: {
                    if showShiny {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")
                    }
                }
            }
        }
        .onAppear {
            // Use this for things at Detail startup
            // Like the pokemon cry if i didnt waste 5 hours trying to fix something that wouldn't work (no im not mad, every failure is a step to success)

        }
    }

    private func currentImageURL() -> URL? {
        if showBack {
            return showShiny ? pokemon.animatedBackShiny : pokemon.animatedBack
        } else {
            return showShiny ? pokemon.animatedFrontShiny : pokemon.animatedFront
        }
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetail()
            .environmentObject(SamplePokemon.samplePokemon)
    }
}
