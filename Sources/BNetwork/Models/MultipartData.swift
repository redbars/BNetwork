
import Foundation

public extension BNetwork {
    enum MultipartData {
        case image_png(Data)
        case image_jpg(Data)
        case image_jpeg(Data)
        case image_gif(Data)
        case doc_xlsx(Data)
        case doc_xls(Data)
        case doc_doc(Data)
        case doc_docx(Data)
        case doc_ppt(Data)
        case doc_pptx(Data)
        case doc_pdf(Data)
        case custom(type: String,
                    data: Data,
                    ext: String)
    }
}

public extension BNetwork.MultipartData {
    var type: String {
        switch self {
        case .image_png: return "image/png"
        case .image_jpg: return "image/jpg"
        case .image_jpeg: return "image/jpeg"
        case .image_gif: return "image/gif"
        case .doc_xls: return "application/vnd.ms-excel"
        case .doc_xlsx: return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case .doc_doc: return "application/msword"
        case .doc_docx: return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case .doc_ppt: return "application/vnd.ms-powerpoint"
        case .doc_pptx: return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case .doc_pdf: return "application/pdf"
        case .custom(let type, _ , _): return type
        }
    }
    
    var data: Data {
        switch self {
        case .image_png(let data): return data
        case .image_jpg(let data): return data
        case .image_jpeg(let data): return data
        case .image_gif(let data): return data
        case .doc_xls(let data): return data
        case .doc_xlsx(let data): return data
        case .doc_doc(let data): return data
        case .doc_docx(let data): return data
        case .doc_ppt(let data): return data
        case .doc_pptx(let data): return data
        case .doc_pdf(let data): return data
        case .custom(_, let data , _): return data
        }
    }
    
    var ext: String {
        switch self {
        case .image_png: return "png"
        case .image_jpg: return "jpg"
        case .image_jpeg: return "jpeg"
        case .image_gif: return "gif"
        case .doc_xls: return "xls"
        case .doc_xlsx: return "xlsx"
        case .doc_doc: return "doc"
        case .doc_docx: return "docx"
        case .doc_ppt: return "ppt"
        case .doc_pptx: return "pptx"
        case .doc_pdf: return "pdf"
        case .custom(_, _, let ext): return ext
        }
    }
}
