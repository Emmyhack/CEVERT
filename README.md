# Cevert - Certificate Verification Smart Contract

Cevert is a decentralized smart contract built on the Ethereum blockchain that provides a mechanism for issuing, verifying, and revoking certificates. The contract allows a proposer to submit a certificate proposal, which requires approval from multiple signers before the certificate is issued. The contract also includes the functionality to revoke certificates and check the validity of existing certificates.

## Features

- **Certificate Proposal**: Any user can propose a certificate for a recipient with a certificate hash and metadata.
- **Approval Process**: The certificate proposal requires approval from a set number of signers before it can be issued.
- **Certificate Issuance**: Once approved, the certificate is issued to the recipient and can be verified on the blockchain.
- **Revocation**: The issuer can revoke a certificate at any time, making it invalid.
- **Verification**: Anyone can verify the validity and metadata of a certificate using its certificate hash.

## Key Components

### 1. **Certificate Proposal Structure**
   - `recipient`: The address of the certificate recipient.
   - `certificateHash`: A unique identifier for the certificate (e.g., a hash of the certificate document).
   - `metadataURI`: A URI containing additional metadata related to the certificate (e.g., a link to the certificate or related document).
   - `approvals`: An array to store addresses of users who approve the certificate.
   - `issued`: A boolean indicating whether the certificate has been issued.

### 2. **Certificate Structure**
   - `issuer`: The address of the user who issued the certificate.
   - `recipient`: The address of the user who received the certificate.
   - `certificateHash`: A unique identifier for the certificate.
   - `metadataURI`: Metadata or additional information about the certificate.
   - `revoked`: A boolean indicating whether the certificate has been revoked.

### 3. **Functions**
   - **`proposeCertificate(address recipient, string memory certificateHash, string memory metadataURI)`**:
     Submits a certificate proposal that requires approval before being issued.
   
   - **`approveCertificate(uint256 proposalId)`**:
     Approves a certificate proposal. Once the required number of approvals is reached, the certificate is issued.
   
   - **`verifyCertificate(string memory certificateHash)`**:
     Verifies if a certificate exists, and returns its metadata and whether it has been revoked.

   - **`revokeCertificate(string memory certificateHash)`**:
     Revokes an issued certificate. Only the issuer can revoke their certificate.

### 4. **Events**
   - **`ProposalCreated(uint256 proposalId, address proposer, address recipient)`**:
     Emitted when a new certificate proposal is created.
   
   - **`ProposalApproved(uint256 proposalId, address approver)`**:
     Emitted when a user approves a certificate proposal.
   
   - **`CertificateIssued(uint256 proposalId, address recipient)`**:
     Emitted when a certificate is issued to a recipient.
   
   - **`CertificateRevoked(string certificateHash)`**:
     Emitted when a certificate is revoked.

