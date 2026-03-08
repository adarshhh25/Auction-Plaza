/**
 * Place Bid DTO
 */
export interface PlaceBidDTO {
  auctionId: string;
  amount: number;
}

/**
 * Bid Response DTO
 */
export interface BidResponseDTO {
  bid: any;
  auction: any;
  auctionExtended?: boolean;
}
