import { AuctionStatus } from '../../models/auction.model';

/**
 * Create Auction DTO
 */
export interface CreateAuctionDTO {
  title: string;
  description: string;
  images: string[];
  startingPrice: number;
  minimumIncrement: number;
  startTime: Date;
  endTime: Date;
}

/**
 * Update Auction Status DTO
 */
export interface UpdateAuctionStatusDTO {
  status: AuctionStatus;
}

/**
 * Auction Query Params
 */
export interface AuctionQueryParams {
  status?: AuctionStatus;
  page?: number;
  limit?: number;
  sort?: string;
}
