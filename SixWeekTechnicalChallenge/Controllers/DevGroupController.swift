//
//  DevGroupController.swift
//  SixWeekTechnicalChallenge
//
//  Created by Cody on 10/5/18.
//  Copyright © 2018 CreakyDoor. All rights reserved.
//

import Foundation

class DevGroupController{
    
    static let shared = DevGroupController()
    private init () {}
    var index = 0
    
    //Sources of Truth
    var devList: [String] = []
    var groupList: [DevGroup] = []
    
    //Create
    func addPerson(person: String){
        devList.append(person)
        createGroups()
        saveToPersistentStore()
    }
    
    func createHelper(){
        if devList.count == 0{
            return
        }else if devList.count - index == 1{
            let newGroup = DevGroup(personOne: devList[index])
            groupList.append(newGroup)
            return
        }else if devList.count - index >= 2{
            
            let newGroup = DevGroup(personOne: devList[index], personTwo: devList[index+1])
            index += 2
            groupList.append(newGroup)
            createHelper()
        }
        index = 0
    }
    
    func shuffleHelper(_ shuffledDevList: [String]){
        
        print(shuffledDevList)
        if shuffledDevList.count == 0{
            return
        }else if shuffledDevList.count - index == 1{
            let newGroup = DevGroup(personOne: shuffledDevList[index])
            groupList.append(newGroup)
            return
        }else if shuffledDevList.count - index >= 2{
            
            let newGroup = DevGroup(personOne: shuffledDevList[index], personTwo: shuffledDevList[index+1])
            index += 2
            groupList.append(newGroup)
            shuffleHelper(shuffledDevList)
        }
        index = 0
    }
    
    func shuffleGroups(){
        groupList = []
        let shuffledDevList = devList.shuffled()
        shuffleHelper(shuffledDevList)
    }
    
    func createGroups(){
        groupList = []
        createHelper()
    }
    
    func fileURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let fileName = "Devlist.json"
        let fullURL = documentsDirectory.appendingPathComponent(fileName)
        return fullURL
    }
    
    func saveToPersistentStore(){
        let encoder = JSONEncoder()
        do{
            let listData = try encoder.encode(devList)
            print(listData)
            try listData.write(to: fileURL())
        }catch{
            print("There was an error Saving to Persistent Store \(error) \(error.localizedDescription) 💩")
            
        }
    }
    
    //READ
    func loadFromPersistentStore() -> [String]{
        do{
            let data = try Data(contentsOf: fileURL())
            let decoder = JSONDecoder()
            let devList = try decoder.decode([String].self, from: data)
            return devList
        } catch {
            print("There was an error Loading from Persistent Store \(error) \(error.localizedDescription) 💩")
        }
        return[]
    }
    
    //UPDATE
    
    //DELETE
    
    func deletePersonFromList(personToDelete: String){
        guard let index = devList.index(of: personToDelete) else {return}
        devList.remove(at: index)
        //deleting wipes groups. Fix later if there is time
        groupList = []
        saveToPersistentStore()
    }
}
