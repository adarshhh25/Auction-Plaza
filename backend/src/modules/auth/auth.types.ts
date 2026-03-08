import { UserRole } from '../../models/user.model';

/**
 * Register Request DTO
 */
export interface RegisterDTO {
  name: string;
  email: string;
  password: string;
  role: UserRole;
}

/**
 * Login Request DTO
 */
export interface LoginDTO {
  email: string;
  password: string;
}

/**
 * Refresh Token Request DTO
 */
export interface RefreshTokenDTO {
  refreshToken: string;
}

/**
 * Auth Response DTO
 */
export interface AuthResponseDTO {
  user: {
    id: string;
    name: string;
    email: string;
    role: UserRole;
    walletBalance: number;
    isVerified: boolean;
  };
  accessToken: string;
  refreshToken: string;
}
