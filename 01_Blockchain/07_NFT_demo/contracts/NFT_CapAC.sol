// SPDX-License-Identifier: MIT
from typing import List
import hashlib

class Node:
    def __init__(self, left, right, value: str, content, is_copied=False) -> None:
        self.left: Node = left
        self.right: Node = right
        self.value = value
        self.content = content
        self.is_copied = is_copied

    def hash(val: str) -> str:
        return hashlib.sha256(val.encode('utf-8')).hexdigest()
    def __str__(self):
        return(str(self.value))
    def copy(self):
        """
        class copy function
        """
        return Node(self.left, self.right, self.value,self.content, True)

class MerkleTree:
    def __init__(self, values: List[str]) -> None:
        self.__buildTree(values)
    def__buildTree(self, values: List[str]) -> None:
        leaves: List[Node] = [Node(None, None, Node.hash(e), e)
                                for e in values]
        if len(leaves) % 2 == 1:
            leaves.append(leaves[-1].copy())
        self.root: Node = self.__buildTreeRec(leaves)
    def __buildTreeRec(self, nodes: List[Node]) -> Node:
        if len(nodes) % 2 == 1:
            nodes.append(nodes[-1].copy())
        half: int = len(nodes) // 2

        if len(nodes) == 2:
            return Node(nodes[0], nodes[1], Node.hash(nodes[0].value + nodes[1].value), nodes[0].content+"+"+nodes[1].content)
        left: Node = self.__buildTreeRec(nodes[:half])
        right: Node = self.__buildTreeRec(nodes[half:])
        value: str = Node.hash(left.value + right.value)
        content: str = f'{left.content}+{right.content}'
        return Node(left, right, value, content)
    def printTree(self) -> None:
        self.__printTreeRec(self.root)
    def__printTreeRec(self, node: Node) -> None:
        if node!= None:
            if node.left != None:
                print("Left: "+str(node.left))
                print("Right: "+str(node.right))
            else:
            if node.is_copied:
                print('(Padding)')
            print("Value: "+str(node.value))
            print("Content: "+str(node.content))
            print("")
            self.__printTreeRec(node.left)
            self.__printTreeRec(node.right)
    def getRootHash(self) -> str:
        retrn self.root.value

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NFT_CapAC
 * This provides a public safeMint, mint, and burn functions for testing purposes
 */
contract NFT_CapAC is ERC721, ERC721Enumerable, Ownable {
    /*
        Define struct to represent capability token data.
    */
    struct CapAC {
        uint id;                // incremental id
        uint256 issuedate;      // token issued date
        uint256 expireddate;    // token expired date
        string authorization;   // authronized access rights
    }

    // Mapping from token ID to CapAC
    mapping(uint256 => CapAC) private _capAC;

    // event handle function
    event OnCapAC_Update(uint256 tokenId, uint _value);

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);

        // mint a CapAC given tokenId
        _mintCapAC(tokenId);
    }

    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public {
        _safeMint(to, tokenId, _data);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
        // mint a CapAC given tokenId
        _burnCapAC(tokenId);
    }

    function query_CapAC(uint256 tokenId) public view returns (uint, 
                                                        uint256, 
                                                        uint256, 
                                                        string memory) {
        // return(id, issuedate, expireddate, authorization);  
        return(_capAC[tokenId].id, 
            _capAC[tokenId].issuedate,
            _capAC[tokenId].expireddate,
            _capAC[tokenId].authorization
            );      
    }

    function _mintCapAC(uint256 tokenId) private {
        _capAC[tokenId].id = 1;
        _capAC[tokenId].issuedate = 0;
        _capAC[tokenId].expireddate = 0;
        _capAC[tokenId].authorization = 'NULL';
    }

    function _burnCapAC(uint256 tokenId) private {
        delete _capAC[tokenId];
    }

    // Set time limitation for a CapAC
    function setCapAC_expireddate(uint256 tokenId, 
                                    uint256 issueddate, 
                                    uint256 expireddate) public {
        require(ownerOf(tokenId) == msg.sender, "NFT_CapAC: setCapAC_expireddate from incorrect owner");

        _capAC[tokenId].id += 1;
        _capAC[tokenId].issuedate = issueddate;
        _capAC[tokenId].expireddate = expireddate;

        emit OnCapAC_Update(tokenId, _capAC[tokenId].id);

    }

    // Assign access rights to a CapAC
    function setCapAC_authorization(uint256 tokenId, 
                                        string memory accessright) public {
        require(ownerOf(tokenId) == msg.sender, "NFT_CapAC: setCapAC_authorization from incorrect owner");

        _capAC[tokenId].id += 1;
        _capAC[tokenId].authorization = accessright;

        emit OnCapAC_Update(tokenId, _capAC[tokenId].id);
   
    }
}
