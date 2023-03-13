//
//  PDFDesign.swift
//  icollect
//
//  Created by user231414 on 3/11/23.
//

import UIKit
import PDFKit
class PDFDesign: NSObject {
    
    let title: String
    let body: String
    let image: UIImage
    let imageSet: [imageSet]?
    
    //overloaded contructor
    init(title: String, body: String, image: UIImage, imageSet: [imageSet]) {
      self.title = title
      self.body = body
      self.image = image
      self.imageSet = imageSet
    }

    func createFlyer() -> Data {
        
        let pdfMetaData = [
            kCGPDFContextCreator: "John King",
            kCGPDFContextAuthor: "johnking.dev",
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            
            let lineSpace = 18.0
            //app data
            var titleBottom = addDesc(pageRect: pageRect, text: "App: icollect", topText: (lineSpace * 2))
            titleBottom = addDesc(pageRect: pageRect, text: "Author: jksapps", topText: titleBottom + lineSpace)
            titleBottom = addDesc(pageRect: pageRect, text: "Website: www.icollect.ca", topText: titleBottom + lineSpace)
            
            //title, collection image and description
            titleBottom = addTitle(pageRect: pageRect, text: title, topText: titleBottom  + (lineSpace * 2))
            let imageBottom = addImage(pageRect: pageRect, imageTop: titleBottom + lineSpace)
            addBodyText(pageRect: pageRect, textTop: imageBottom + lineSpace)
            
            //Add Body Images
            context.beginPage()
            titleBottom = addTitle(pageRect: pageRect, text: title, topText: (lineSpace * 2))
            var topPos = titleBottom + lineSpace
            var sidePos = 0.0
            for img in imageSet! {
                //end of page width
                if sidePos > 391 {
                    topPos += 150.5
                    sidePos = 0.0
                }
                //end of page
                if topPos > 600 {
                    //new page to place extra images
                    context.beginPage()
                    titleBottom = addTitle(pageRect: pageRect, text: title, topText: (lineSpace * 2))
                    topPos = titleBottom + lineSpace
                }
                sidePos = addSmallImage(pageRect: pageRect, imageTop: topPos, imageSide: sidePos, img: img)
            }
        }
        
        return data
    }
   
    //MARK: Add Tiitle
    func addTitle(pageRect: CGRect, text: String, topText: CGFloat) -> CGFloat {

      let titleFont = UIFont.systemFont(ofSize: 20.0, weight: .bold)
      let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
      let attributedTitle = NSAttributedString(
        string: text,
        attributes: titleAttributes
      )
      let titleStringSize = attributedTitle.size()
      let titleStringRect = CGRect(
        x: (pageRect.width - titleStringSize.width) / 2.0,
        y: topText,
        width: titleStringSize.width,
        height: titleStringSize.height
      )
      attributedTitle.draw(in: titleStringRect)
      return titleStringRect.origin.y + titleStringRect.size.height
    }
    //MARK: Add Description
    func addDesc(pageRect: CGRect, text: String, topText: CGFloat) -> CGFloat {

      let titleFont = UIFont.systemFont(ofSize: 38.0, weight: .regular)
      let titleAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: titleFont]
      let attributedTitle = NSAttributedString(string: text, attributes: titleAttributes)
      let titleStringSize = attributedTitle.size()
      let titleStringRect = CGRect(
        x: (pageRect.width - titleStringSize.width) / 2.0,
        y: topText,
        width: titleStringSize.width,
        height: titleStringSize.height
      )
      attributedTitle.draw(in: titleStringRect)
      return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    //MARK: Add Body
    func addBodyText(pageRect: CGRect, textTop: CGFloat){
      let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)

      let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
      paragraphStyle.lineBreakMode = .byWordWrapping

      let textAttributes = [
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.font: textFont
      ]
      let attributedText = NSAttributedString(string: body, attributes: textAttributes)

      let textRect = CGRect(
        x: 10,
        y: textTop,
        width: pageRect.width - 20,
        height: pageRect.height - textTop - pageRect.height / 5.0
      )
      attributedText.draw(in: textRect)
    }
    
    //MARK: Add Image
    func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {

      let maxHeight = pageRect.height * 0.4
      let maxWidth = pageRect.width * 0.8

      let aspectWidth = maxWidth / image.size.width
      let aspectHeight = maxHeight / image.size.height
      let aspectRatio = min(aspectWidth, aspectHeight)

      let scaledWidth = image.size.width * aspectRatio
      let scaledHeight = image.size.height * aspectRatio

      let imageX = (pageRect.width - scaledWidth) / 2.0
      let imageRect = CGRect(x: imageX, y: imageTop,
                             width: scaledWidth, height: scaledHeight)
      image.draw(in: imageRect)
      return imageRect.origin.y + imageRect.size.height
    }
    
    //MARK: Add Small Image
    func addSmallImage(pageRect: CGRect, imageTop: CGFloat, imageSide: CGFloat, img: imageSet) -> CGFloat {

      let maxHeight = pageRect.height * 0.145
        let maxWidth = pageRect.width * 0.29

        let aspectWidth = maxWidth / img.image.size.width
        let aspectHeight = maxHeight / img.image.size.height
      let aspectRatio = min(aspectWidth, aspectHeight)

        let scaledWidth = img.image.size.width * aspectRatio
        let scaledHeight = img.image.size.height * aspectRatio

      let imageX = ((pageRect.width - (scaledWidth * 2)) / 3.0)/4
      let imageRect = CGRect(x: imageX + imageSide, y: imageTop, width: scaledWidth, height: scaledHeight)
        
        let textRect = CGRect(x: imageX + imageSide, y: imageTop + maxHeight + 10.0, width: maxWidth, height: scaledHeight)
        
        img.image.draw(in: imageRect)
        img.name.draw(in: textRect)
       // print("image top -> \(imageRect.origin.y + imageRect.size.height + 18.0)")
        return imageSide + maxWidth}
}
