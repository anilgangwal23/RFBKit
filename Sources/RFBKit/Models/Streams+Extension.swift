//
//  Streams+Extension.swift
//  
//
//  Created by Henrik Storch on 16.06.21.
//

import Foundation

extension InputStream {
    
    /// Reads bytes from the stream
    /// - Parameter maxLength: The maximum number of bytes to read
    /// - Returns: The bytes read, if no error occured.
    func readBytes(maxLength: Int = 4096) -> [UInt8]? {
        var buffer = [UInt8](repeating: 0, count: maxLength)
       // while (inputStream!.hasBytesAvailable){
        //}

        let outcome = self.read(&buffer, maxLength: buffer.count)
        guard outcome >= 0 else {
            //0: end reached
            //-1: error
            return nil
        }
        
        return buffer
    }
    
    /// Reads exactly `count` bytes, looping until all of them have arrived.
    /// A single `read` may return fewer bytes than requested.
    /// - Returns: The bytes read, or `nil` if the stream ended or failed first.
    func readExactBytes(count: Int) -> [UInt8]? {
        var buffer = [UInt8](repeating: 0, count: count)
        var offset = 0
        while offset < count {
            let outcome = buffer.withUnsafeMutableBufferPointer { pointer in
                read(pointer.baseAddress! + offset, maxLength: count - offset)
            }
            guard outcome > 0 else { return nil }
            offset += outcome
        }
        return buffer
    }
    
    /// Reads exactly `count` bytes as `Data`
    func readExactData(count: Int) -> Data? {
        readExactBytes(count: count).map { Data($0) }
    }
    
    /// Reads 16 bits in network (big-endian) byte order
    func readExactUInt16BE() -> UInt16? {
        guard let bytes = readExactBytes(count: 2) else { return nil }
        return UInt16(bytes[0]) << 8 | UInt16(bytes[1])
    }
    
    /// Reads bytes from the stream
    /// - Parameter maxLength: The maximum number of bytes to read
    /// - Returns: The bytes read as `Data`
    func readData(maxLength: Int = 4096) -> Data? {
        guard let bytes: [UInt8] = readBytes(maxLength: maxLength) else { return nil }
        return Data(bytes: bytes, count: bytes.count)
    }

    /// Reads bytes from the stream
    /// - Parameter maxLength: The maximum number of bytes to read
    /// - Returns: The bytes read as `String`
    func readString(maxLength: Int = 4096) -> String? {
        guard let data: Data = readData(maxLength: maxLength) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    
    /// Reads 32 bits and ineprets them as a `UInt32`
    /// - Returns: The `UInt32` value of the bytes read
    func readUInt32() -> UInt32? {
        guard let bytes = self.readBytes(maxLength: 4) else { return nil }
        return UInt32(bytes)
    }
    
    /// Reads 16 bits and ineprets them as a `UInt16`
    /// - Returns: The `UInt16` value of the bytes read
    func readUInt16() -> UInt16? {
        guard let bytes = self.readBytes(maxLength: 2) else { return nil }
        return UInt16(bytes)
    }
    
    /// Reads 8 bits aka one byte
    /// - Returns: The byte read
    func readUInt8() -> UInt8? {
        guard let bytes = self.readBytes(maxLength: 1) else { return nil }
        return UInt8(bytes)
    }
    
    /// Reads 8 bits and ineprets them as a `Int8`
    /// - Returns: The `Int8` value of the bytes read
    func readInt8() -> Int8? {
        guard let bytes = self.readBytes(maxLength: 1) else { return nil }
        return Int8(bytes)
    }
    
    /// Reads 16 bits and ineprets them as a `Int16`
    /// - Returns: The `Int16` value of the bytes read
    func readInt16() -> Int16? {
        guard let bytes = self.readBytes(maxLength: 2) else { return nil }
        return Int16(bytes)
    }
    
    /// Reads 32 bits and ineprets them as a `Int32`
    /// - Returns: The `Int32` value of the bytes read
    func readInt32() -> Int32? {
        guard let bytes = self.readBytes(maxLength: 4) else { return nil }
        return Int32(bytes)
    }
}


extension OutputStream {
    func write(bytes: [UInt8]) {
        var response = [UInt8](bytes)
        self.write(&response, maxLength: response.count)
    }
    
    func write(data: Data) {
        self.write(bytes: [UInt8](data))
    }
    
    func write(string: String) {
        self.write(bytes: [UInt8](string.utf8))
    }
}
