// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Certificate Verification (cervert) contract
contract Cevert {

    struct CertificateProposal {
        address recipient;
        string certificateHash;
        string metadataURI;
        address[] approvals;
        bool issued;
    }

    struct Certificate {
        address issuer;
        address recipient;
        string certificateHash;
        string metadataURI;
        bool revoked;
    }

    mapping(uint256 => CertificateProposal) public proposals;
    mapping(string => Certificate) public certificates;
    uint256 public proposalCount;
    address[] public signers;
    uint256 public requiredApprovals;

    event ProposalCreated(uint256 proposalId, address proposer, address recipient);
    event ProposalApproved(uint256 proposalId, address approver);
    event CertificateIssued(uint256 proposalId, address recipient);
    event CertificateRevoked(string certificateHash);

    constructor(uint256 _requiredApprovals) {
        require(_requiredApprovals > 0, "Required approvals must be greater than 0");
        requiredApprovals = _requiredApprovals;
    }

    function proposeCertificate(
        address recipient,
        string memory certificateHash,
        string memory metadataURI
    ) public {
        require(recipient != address(0), "Invalid recipient");
        require(bytes(certificateHash).length > 0, "Invalid certificate hash");
        require(bytes(metadataURI).length > 0, "Invalid metadata URI");

        proposalCount++;
        proposals[proposalCount] = CertificateProposal({
            recipient: recipient,
            certificateHash: certificateHash,
            metadataURI: metadataURI,
            approvals: new address[](0),
            issued: false
        });
        emit ProposalCreated(proposalCount, msg.sender, recipient);
    }

    function approveCertificate(uint256 proposalId) public {
        require(proposalId > 0, "Invalid proposal ID");
        CertificateProposal storage proposal = proposals[proposalId];
        require(!proposal.issued, "Certificate already issued");
        require(!hasApproved(proposalId, msg.sender), "Already approved");

        proposal.approvals.push(msg.sender);

        emit ProposalApproved(proposalId, msg.sender);

        if (proposal.approvals.length >= requiredApprovals) {
            proposal.issued = true;

            certificates[proposal.certificateHash] = Certificate({
                issuer: msg.sender,
                recipient: proposal.recipient,
                certificateHash: proposal.certificateHash,
                metadataURI: proposal.metadataURI,
                revoked: false
            });

            emit CertificateIssued(proposalId, proposal.recipient);
        }
    }

    function hasApproved(uint256 proposalId, address signer) internal view returns (bool) {
        CertificateProposal storage proposal = proposals[proposalId];
        for (uint256 i = 0; i < proposal.approvals.length; i++) {
            if (proposal.approvals[i] == signer) {
                return true;
            }
        }
        return false;
    }

    function verifyCertificate(string memory certificateHash)
        public view returns (bool exists, string memory metadataURI, bool revoked)
    {
        Certificate memory cert = certificates[certificateHash];
        if (cert.issuer == address(0)) {
            return (false, "", false);
        }
        return (true, cert.metadataURI, cert.revoked);
    }

    function revokeCertificate(string memory certificateHash) public {
        Certificate storage cert = certificates[certificateHash];
        require(cert.issuer != address(0), "Certificate does not exist");
        cert.revoked = true;

        emit CertificateRevoked(certificateHash);
    }
}
