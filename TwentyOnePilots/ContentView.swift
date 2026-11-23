//
//  ContentView.swift
//  TwentyOnePilots
//
//  Created by Guest User on 14/10/26.
//

import SwiftUI

struct ContentView: View {
    //Guarda la pantalla a la que vamos con los gestos
    @State private var ruta: [String] = []

    var body: some View {
        NavigationStack(path: $ruta){
            //Sin ScrollView para que los gestos arriba/abajo no choquen con el scroll
            VStack (spacing: 12){
                Text("Twenty One Pilots").font(.title).bold().multilineTextAlignment(.center)
                Text("Duo de Columbus, Ohio").foregroundStyle(.secondary)
                Image("top1").resizable().scaledToFit().frame(maxHeight: 170).clipShape(RoundedRectangle(cornerRadius: 16))
                Text("Twenty One Pilots es un duo formado en 2009 por Tyler Joseph y Josh Dun. Mezclan rock alternativo, pop, rap y electronica, y sus albumes cuentan la historia de Clancy y la ciudad de Dema. A sus fans se les conoce como la Skeleton Clique.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                Text("Selecciona lo que deseas conocer").font(.headline)

                NavigationLink{
                    AlbumesView()
                } label: {
                    BotonMenu(
                        titulo: "Albumes",
                        simbolo: "opticaldisc",
                        color: .red
                    )
                }

                NavigationLink{
                    IntegrantesView()
                } label: {
                    BotonMenu(
                        titulo: "Integrantes",
                        simbolo: "person.2",
                        color: .orange
                    )
                }

                NavigationLink{
                    LogrosView()
                } label: {
                    BotonMenu(
                        titulo: "Logros",
                        simbolo: "trophy",
                        color: .yellow
                    )
                }

                NavigationLink{
                    PeliculaView()
                } label: {
                    BotonMenu(
                        titulo: "Pelicula",
                        simbolo: "film",
                        color: .purple
                    )
                }

                //Ayuda para los gestos
                Text("Desliza:\n← Albumes   → Integrantes\n↑ Logros   ↓ Pelicula")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.05))
            .navigationTitle("|-/ Twenty One Pilots")
            .navigationBarTitleDisplayMode(.inline)
            .simultaneousGesture(
                DragGesture(minimumDistance: 30).onEnded { gesto in
                    let x = gesto.translation.width
                    let y = gesto.translation.height
                    if abs(x) > abs(y) {
                        if x < -80 { ruta.append("albumes") }
                        if x > 80 { ruta.append("integrantes") }
                    } else {
                        if y < -80 { ruta.append("logros") }
                        if y > 80 { ruta.append("pelicula") }
                    }
                }
            )
            .navigationDestination(for: String.self) { pantalla in
                if pantalla == "albumes" { AlbumesView() }
                if pantalla == "integrantes" { IntegrantesView() }
                if pantalla == "logros" { LogrosView() }
                if pantalla == "pelicula" { PeliculaView() }
            }
        }
    }
}

//Diseno reutilizable para los botones
struct BotonMenu: View {
    let titulo: String
    let simbolo: String
    let color: Color

    var body: some View {
        HStack(spacing: 12){
            Image(systemName: simbolo).font(.title2).frame(width: 30)
            Text(titulo).font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

//Boton regresar
struct BotonRegresar: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button{
            dismiss()
        } label: {
            Label("Regresar al inicio", systemImage: "arrow.left")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

//Tarjeta con imagen, nombre, dato y descripcion
struct Tarjeta: View {
    let imagen: String
    let nombre: String
    let dato: String
    let descripcion: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Image(imagen).resizable().scaledToFit().frame(maxWidth: .infinity).clipShape(RoundedRectangle(cornerRadius: 12))
            Text(nombre).font(.title3).bold()
            Text(dato).foregroundStyle(.secondary)
            Text(descripcion).font(.body).lineSpacing(4)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

//Pantalla reutilizable con varias tarjetas
struct PantallaInformativa<Contenido: View>: View {
    @Environment(\.dismiss) private var dismiss
    let titulo: String
    let simbolo: String
    @ViewBuilder let contenido: Contenido

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 24) {
                Image(systemName: simbolo)
                    .font(.system(size: 60))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                Text(titulo)
                    .font(.title)
                    .bold()
                Text("Desliza a la derecha para regresar").font(.footnote).foregroundStyle(.secondary)

                contenido

                BotonRegresar()
            }
            .padding()
        }
        .navigationTitle(titulo)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        //Gesto para regresar deslizando a la derecha
        .simultaneousGesture(
            DragGesture(minimumDistance: 30).onEnded { gesto in
                if gesto.translation.width > 80 && abs(gesto.translation.height) < 80 {
                    dismiss()
                }
            }
        )
    }
}

struct AlbumesView: View {
    var body: some View {
        PantallaInformativa(titulo: "Albumes", simbolo: "opticaldisc") {
            Tarjeta(imagen: "regionalatbest", nombre: "Regional at Best", dato: "8 de julio de 2011",
                    descripcion: "Su segundo album, lanzado de forma independiente. Fue el primero con Josh Dun en la bateria y varias de sus canciones despues se volvieron a grabar para Vessel.")
            Tarjeta(imagen: "vessel", nombre: "Vessel", dato: "8 de enero de 2013",
                    descripcion: "Su primer album con la disquera Fueled by Ramen. Incluye canciones como Car Radio, Holding On to You y House of Gold.")
            Tarjeta(imagen: "blurryface", nombre: "Blurryface", dato: "17 de mayo de 2015",
                    descripcion: "El album que los hizo famosos en todo el mundo. Habla de Blurryface, un personaje que representa las inseguridades. Tiene exitos como Stressed Out, Ride y Tear in My Heart.")
            Tarjeta(imagen: "trench", nombre: "Trench", dato: "5 de octubre de 2018",
                    descripcion: "Album conceptual que presenta la ciudad de Dema y a Clancy. Tiene un sonido mas oscuro con canciones como Jumpsuit, Chlorine y My Blood.")
            Tarjeta(imagen: "scaledandicy", nombre: "Scaled and Icy", dato: "21 de mayo de 2021",
                    descripcion: "Fue hecho durante la pandemia y tiene un sonido mas alegre y colorido. Destacan Shy Away, Saturday y The Outside.")
            Tarjeta(imagen: "clancy", nombre: "Clancy", dato: "24 de mayo de 2024",
                    descripcion: "Cierra la historia de Dema que empezo en Blurryface. Incluye Overcompensate, Next Semester y Backslide.")
            Tarjeta(imagen: "breach", nombre: "Breach", dato: "12 de septiembre de 2025",
                    descripcion: "Su octavo album de estudio. Retoma sonidos de sus primeros discos y trae canciones como The Contract y City Walls.")
        }
    }
}

struct IntegrantesView: View {
    var body: some View {
        PantallaInformativa(titulo: "Integrantes", simbolo: "person.2") {
            Tarjeta(imagen: "tyler", nombre: "Tyler Joseph", dato: "Vocalista y compositor",
                    descripcion: "Fundo la banda en 2009. Canta, escribe casi todas las letras y toca el piano, el ukulele y el bajo. Tambien produce gran parte de la musica.")
            Tarjeta(imagen: "josh", nombre: "Josh Dun", dato: "Baterista",
                    descripcion: "Se unio a la banda en 2011. Toca la bateria y la percusion, a veces la trompeta, y es famoso por sus saltos mortales en los conciertos.")
        }
    }
}

struct LogrosView: View {
    var body: some View {
        PantallaInformativa(titulo: "Logros", simbolo: "trophy") {
            Tarjeta(imagen: "grammy", nombre: "Premio Grammy", dato: "2017 - Mejor Interpretacion Pop de Duo o Grupo",
                    descripcion: "Ganaron el Grammy por Stressed Out. Subieron a recibirlo en ropa interior porque, antes de ser famosos, prometieron que si algun dia ganaban lo harian asi.")
            Text("OTROS LOGROS\nBlurryface fue el primer album en la historia en que todas sus canciones fueron certificadas oro o mas en Estados Unidos.\n\nHeathens y Stressed Out estuvieron al mismo tiempo en el top 5 del Billboard Hot 100.\n\nTambien han ganado premios American Music Awards y Billboard Music Awards.")
                .font(.body)
                .lineSpacing(6)
        }
    }
}

struct PeliculaView: View {
    var body: some View {
        PantallaInformativa(titulo: "Pelicula", simbolo: "film") {
            Tarjeta(imagen: "pelicula", nombre: "More Than We Ever Imagined", dato: "En vivo en la Ciudad de Mexico",
                    descripcion: "Pelicula de concierto grabada en la Ciudad de Mexico durante su gira, frente a miles de fans. Muestra el show completo y momentos de la banda con su publico.")
        }
    }
}
//#Preview {
  //  ContentView()
//}
