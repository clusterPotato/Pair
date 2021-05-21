//
//  groupAndPersonController.swift
//  Pair Randomizer
//
//  Created by Gavin Craft on 5/21/21.
//

import Foundation

protocol RandomDelegate:AnyObject{ //wow such great name
    func wasRandomized()
}
class GroupController{
    static let shared = GroupController()
    var pairs: [Pair] = []{didSet{delegate?.wasRandomized()}}
    var ungroupedPeople: [Man] = []
    var cachedPeople: [Man] = []
    weak var delegate: RandomDelegate?
    init(){
        pairs = []
        loadFromPersistenceStore()
        print(cachedPeople.count)
        ungroupedPeople = cachedPeople
        groupPeople()
    }
    //MARK: - funcs
    func createPerson(name: String){
        let person = Man(name: name)
        ungroupedPeople.append(person)
        cachedPeople.append(person)
        saveToPersistenceStore()
    }
    func deleteLoosePerson(_ p: Man){
        if let index = ungroupedPeople.firstIndex(of: p){
            ungroupedPeople.remove(at: index)
        }
        if let index = cachedPeople.firstIndex(of: p){
            cachedPeople.remove(at: index)
        }
        for i in pairs.indices{
            if let index = pairs[i].people.firstIndex(of: p){
                pairs[i].people.remove(at: index)
                break
            }
        }
        saveToPersistenceStore()
    }
    func randomize(){
        pairs = []
        ungroupedPeople = cachedPeople
        groupPeople()
    }
    func groupPeople(){
        if ungroupedPeople.count.isEven(){
            while !(ungroupedPeople.isEmpty){
                generateAndAddPair()
            }
        }else if ungroupedPeople.count.isOdd(){
            while !(ungroupedPeople.count==1){
                generateAndAddPair()
            }
            putStragglerInGroup()
        }
        print("pairs is \(pairs.count)")
    }
    func putStragglerInGroup(){
        pairs.append(Pair(people: [ungroupedPeople[0]]))
        ungroupedPeople.remove(at: 0)
    }
    private func generateAndAddPair(){
        var index = Int.random(in: ungroupedPeople.indices)
        let person1 = ungroupedPeople[index]
        ungroupedPeople.remove(at: index)
        index = Int.random(in: ungroupedPeople.indices)
        let person2 = ungroupedPeople[index]
        ungroupedPeople.remove(at: index)
        let pair = Pair(people: [person1,person2])
        print("pair is\(pair.people.count) long")
        pairs.append(pair)
    }
}
//MARK: - save names
extension GroupController{
    //MARK: -  persistence
    func createPersistenceStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("loosePeople.json")
        return fileURL
    }
    func saveToPersistenceStore(){
        do{
            let data = try JSONEncoder().encode(cachedPeople)
            try data.write(to: createPersistenceStore())
        }catch{
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    func loadFromPersistenceStore(){
        do{
            let data = try Data(contentsOf: createPersistenceStore())
            cachedPeople = try JSONDecoder().decode([Man].self, from: data)
        }catch{
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
}
extension Int{
    func isEven()->Bool{
        return self%2==0
    }
    func isOdd()->Bool{
        return !isEven()
    }
}
