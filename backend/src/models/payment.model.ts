import mongoose, { Schema, Document, Model } from 'mongoose';

/**
 * Payment Status Enumeration
 */
export enum PaymentStatus {
  PENDING = 'Pending',
  COMPLETED = 'Completed',
  FAILED = 'Failed',
}

/**
 * Payment Interface
 */
export interface IPayment extends Document {
  user: mongoose.Types.ObjectId;
  auction: mongoose.Types.ObjectId;
  amount: number;
  status: PaymentStatus;
  transactionId: string;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Payment Schema Definition
 */
const PaymentSchema: Schema<IPayment> = new Schema(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User is required'],
    },
    auction: {
      type: Schema.Types.ObjectId,
      ref: 'Auction',
      required: [true, 'Auction is required'],
    },
    amount: {
      type: Number,
      required: [true, 'Amount is required'],
      min: [0.01, 'Amount must be greater than 0'],
    },
    status: {
      type: String,
      enum: Object.values(PaymentStatus),
      default: PaymentStatus.PENDING,
    },
    transactionId: {
      type: String,
      required: [true, 'Transaction ID is required'],
      unique: true,
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
PaymentSchema.index({ user: 1 });
PaymentSchema.index({ auction: 1 });

/**
 * Payment Model
 */
const Payment: Model<IPayment> = mongoose.model<IPayment>('Payment', PaymentSchema);

export default Payment;
