import mongoose, { Schema, Document, Model } from 'mongoose';

/**
 * Bid Interface
 */
export interface IBid extends Document {
  auction: mongoose.Types.ObjectId;
  bidder: mongoose.Types.ObjectId;
  amount: number;
  isWinningBid: boolean;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Bid Schema Definition
 */
const BidSchema: Schema<IBid> = new Schema(
  {
    auction: {
      type: Schema.Types.ObjectId,
      ref: 'Auction',
      required: [true, 'Auction is required'],
    },
    bidder: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Bidder is required'],
    },
    amount: {
      type: Number,
      required: [true, 'Bid amount is required'],
      min: [0.01, 'Bid amount must be greater than 0'],
    },
    isWinningBid: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
    toJSON: {
      transform: function (_doc, ret) {
        delete (ret as any).__v;
        return ret;
      },
    },
  }
);

/**
 * Indexes for optimized queries
 */
BidSchema.index({ auction: 1, amount: -1 }); // Compound index for finding highest bids
BidSchema.index({ bidder: 1 });
BidSchema.index({ auction: 1, createdAt: -1 }); // For bid history

/**
 * Bid Model
 */
const Bid: Model<IBid> = mongoose.model<IBid>('Bid', BidSchema);

export default Bid;
