//
//  Form781pdfFiller.swift
//  Logging
//
//  Created by John Bethancourt on 12/21/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation
import PDFKit

struct Form781pdfFiller{
    
    let form781: Form781!
    
    func pdfDocument() -> PDFDocument? {
        guard let path = Bundle.main.path(forResource: "fillable781", ofType: "pdf") else { return nil }
        guard let pdf = PDFDocument(url: URL(fileURLWithPath: path)) else { return nil }
        
        let pageAnnotationDictionaries = createPDFFieldLocationDictionaries(for: pdf)
        
        let filledPDF = fillPDF(pdf, with: form781, using: pageAnnotationDictionaries)
        
        return filledPDF
    }
    
    func pdfURL() -> URL? {
        
        let pdf = pdfDocument()
        let data = pdf?.dataRepresentation()
        
        do {
            
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            var savePath = paths[0]
            savePath = savePath.appendingPathComponent("filled781.pdf")
            
            try data?.write(to: savePath, options: .completeFileProtectionUnlessOpen)
            
        }catch{
            print("PDF Saive Failure.")
            return nil
        }
        
        return URL(fileURLWithPath: "")
    }
    
    func fillPDF(_ pdf: PDFDocument, with formData: Form781, using pageAnnotationDictionaries:[[String: CGPoint]]) -> PDFDocument {
        
        let page0 = pdf.page(at:0)
        
        let page0dict = pageAnnotationDictionaries[0]
        
        page0?.annotation(at: page0dict["date"]!)?          .setText(formData.date)
        page0?.annotation(at: page0dict["mds"]!)?           .setText(formData.mds)
        page0?.annotation(at: page0dict["serial"]!)?        .setText(formData.serialNumber)
        page0?.annotation(at: page0dict["unit_charged"]!)?  .setText(formData.unitCharged)
        page0?.annotation(at: page0dict["harm_location"]!)? .setText(formData.harmLocation)
        page0?.annotation(at: page0dict["flight_auth"]!)?   .setText(formData.flightAuthNum)
        page0?.annotation(at: page0dict["issuing_unit"]!)?  .setText(formData.issuingUnit)
        
        //Fill out flight data section
        //max 6 even if flights somehow contains more
        for i in 0..<min(formData.flights.count, 6) {
            page0?.annotation(at: page0dict["mission_number_\(i)"]!)?   .setText(formData.flights[i].missionNumber)
            page0?.annotation(at: page0dict["mission_symbol_\(i)"]!)?   .setText(formData.flights[i].missionSymbol)
            page0?.annotation(at: page0dict["from_icao_\(i)"]!)?        .setText(formData.flights[i].fromICAO)
            page0?.annotation(at: page0dict["to_icao_\(i)"]!)?          .setText(formData.flights[i].toICAO)
            page0?.annotation(at: page0dict["take_off_time_\(i)"]!)?    .setText(formData.flights[i].takeOffTime)
            page0?.annotation(at: page0dict["land_time_\(i)"]!)?        .setText(formData.flights[i].landTime)
            page0?.annotation(at: page0dict["total_time_\(i)"]!)?        .setText(formData.flights[i].totalTime)
            page0?.annotation(at: page0dict["touch_go_\(i)"]!)?         .setText(formData.flights[i].touchAndGo)
            page0?.annotation(at: page0dict["full_stop_\(i)"]!)?        .setText(formData.flights[i].fullStop)
            page0?.annotation(at: page0dict["total_\(i)"]!)?            .setText(formData.flights[i].totalLandings)
            page0?.annotation(at: page0dict["sorties_\(i)"]!)?          .setText(formData.flights[i].sorties)
            page0?.annotation(at: page0dict["special_use_\(i)"]!)?      .setText(formData.flights[i].specialUse)
            
        }
        
        //Fill out crew member section
        //zeroeth to max on front page
        for i in 0..<min(formData.crewMembers.count, 15){
            page0?.annotation(at: page0dict["organization_\(i)"]!)?         .setText(formData.crewMembers[i].flyingOranization)
            page0?.annotation(at: page0dict["ssan_\(i)"]!)?                 .setText(formData.crewMembers[i].ssnLast4)
            page0?.annotation(at: page0dict["last_name_\(i)"]!)?            .setText(formData.crewMembers[i].lastName)
            page0?.annotation(at: page0dict["flight_auth_\(i)"]!)?          .setText(formData.crewMembers[i].flightAuthDutyCode)
            page0?.annotation(at: page0dict["ft_prim_\(i)"]!)?              .setText(formData.crewMembers[i].primary)
            page0?.annotation(at: page0dict["ft_sec_\(i)"]!)?               .setText(formData.crewMembers[i].secondary)
            page0?.annotation(at: page0dict["ft_instr_\(i)"]!)?             .setText(formData.crewMembers[i].instructor)
            page0?.annotation(at: page0dict["ft_eval_\(i)"]!)?              .setText(formData.crewMembers[i].evaluator)
            page0?.annotation(at: page0dict["ft_other_\(i)"]!)?             .setText(formData.crewMembers[i].other)
            page0?.annotation(at: page0dict["ft_total_time_\(i)"]!)?        .setText(formData.crewMembers[i].time)
            page0?.annotation(at: page0dict["ft_total_srty_\(i)"]!)?        .setText(formData.crewMembers[i].srty)
            page0?.annotation(at: page0dict["fc_night_\(i)"]!)?             .setText(formData.crewMembers[i].nightPSIE)
            page0?.annotation(at: page0dict["fc_ins_\(i)"]!)?               .setText(formData.crewMembers[i].insPIE)
            page0?.annotation(at: page0dict["fc_sim_ins_\(i)"]!)?           .setText(formData.crewMembers[i].simIns)
            page0?.annotation(at: page0dict["fc_nvg_\(i)"]!)?               .setText(formData.crewMembers[i].nvg)
            page0?.annotation(at: page0dict["fc_combat_time_\(i)"]!)?       .setText(formData.crewMembers[i].combatTime)
            page0?.annotation(at: page0dict["fc_combat_srty_\(i)"]!)?       .setText(formData.crewMembers[i].combatSrty)
            page0?.annotation(at: page0dict["fc_combat_spt_time_\(i)"]!)?   .setText(formData.crewMembers[i].combatSptTime)
            page0?.annotation(at: page0dict["fc_combat_spt_srty_\(i)"]!)?   .setText(formData.crewMembers[i].combatSptSrty)
            page0?.annotation(at: page0dict["resv_status_\(i)"]!)?          .setText(formData.crewMembers[i].resvStatus)
            
        }
        
        if formData.crewMembers.count > 14{
            let page1 = pdf.page(at:1)
            let page1dict = pageAnnotationDictionaries[1]
            
            
            for i in 15..<min(formData.crewMembers.count, 35){
                
                page1?.annotation(at: page1dict["organization_\(i)"]!)?         .setText(formData.crewMembers[i].flyingOranization)
                page1?.annotation(at: page1dict["ssan_\(i)"]!)?                 .setText(formData.crewMembers[i].ssnLast4)
                page1?.annotation(at: page1dict["last_name_\(i)"]!)?            .setText(formData.crewMembers[i].lastName)
                page1?.annotation(at: page1dict["flight_auth_\(i)"]!)?          .setText(formData.crewMembers[i].flightAuthDutyCode)
                page1?.annotation(at: page1dict["ft_prim_\(i)"]!)?              .setText(formData.crewMembers[i].primary)
                page1?.annotation(at: page1dict["ft_sec_\(i)"]!)?               .setText(formData.crewMembers[i].secondary)
                page1?.annotation(at: page1dict["ft_instr_\(i)"]!)?             .setText(formData.crewMembers[i].instructor)
                page1?.annotation(at: page1dict["ft_eval_\(i)"]!)?              .setText(formData.crewMembers[i].evaluator)
                page1?.annotation(at: page1dict["ft_other_\(i)"]!)?             .setText(formData.crewMembers[i].other)
                page1?.annotation(at: page1dict["ft_total_time_\(i)"]!)?        .setText(formData.crewMembers[i].time)
                page1?.annotation(at: page1dict["ft_total_srty_\(i)"]!)?        .setText(formData.crewMembers[i].srty)
                page1?.annotation(at: page1dict["fc_night_\(i)"]!)?             .setText(formData.crewMembers[i].nightPSIE)
                page1?.annotation(at: page1dict["fc_ins_\(i)"]!)?               .setText(formData.crewMembers[i].insPIE)
                page1?.annotation(at: page1dict["fc_sim_ins_\(i)"]!)?           .setText(formData.crewMembers[i].simIns)
                page1?.annotation(at: page1dict["fc_nvg_\(i)"]!)?               .setText(formData.crewMembers[i].nvg)
                page1?.annotation(at: page1dict["fc_combat_time_\(i)"]!)?       .setText(formData.crewMembers[i].combatTime)
                page1?.annotation(at: page1dict["fc_combat_srty_\(i)"]!)?       .setText(formData.crewMembers[i].combatSrty)
                page1?.annotation(at: page1dict["fc_combat_spt_time_\(i)"]!)?   .setText(formData.crewMembers[i].combatSptTime)
                page1?.annotation(at: page1dict["fc_combat_spt_srty_\(i)"]!)?   .setText(formData.crewMembers[i].combatSptSrty)
                page1?.annotation(at: page1dict["resv_status_\(i)"]!)?          .setText(formData.crewMembers[i].resvStatus)
            }
            
        }
        
        return pdf
    }
    
    func createPDFFieldLocationDictionaries(for pdf: PDFDocument) -> [[String: CGPoint]] {
        var pageAnnotationDictionaries = [[String : CGPoint]]()
        
        for i in 0..<pdf.pageCount{
            
            var annotationDictionary = [String : CGPoint]()
            let page = pdf.page(at: i)
            
            // go through every annotation on the page and fill the dictionary with the field name and origin
            for annotation in page!.annotations{
                annotationDictionary[annotation.fieldName!] = annotation.bounds.origin
                
            }
            //add page annotation dictionary
            pageAnnotationDictionaries.append(annotationDictionary)
            
        }
        return pageAnnotationDictionaries
    }
    
}

extension PDFAnnotation{
    func setText(_ string: String?){
        let page = self.page
        page?.removeAnnotation(self)
        self.setValue(string ?? "", forAnnotationKey: .widgetValue)
        page?.addAnnotation(self)
    }
}

 
